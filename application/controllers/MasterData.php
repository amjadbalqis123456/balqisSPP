<?php
defined('BASEPATH') or exit('No direct script access allowed');







class MasterData extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();

        if (empty($this->session->userdata('username')) || $this->session->userdata('level') != 'Admin') {
            redirect('auth/blocked');
        }

        $this->load->model('Account_model', 'Account');
        $this->load->model('Data_model', 'Data');
    }



    /*----------------------------------------------------------
    
        CRUD untuk data petugas
    
    ----------------------------------------------------------*/






    public function Petugas()
    {
        $data['title'] = 'Data Petugas';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['petugas'] = $this->Data->petugas_get();
        $this->load->view('templates/header', $data);
        $this->load->view('templates/navbar', $data);
        $this->load->view('templates/sidebar', $data);
        $this->load->view('master/petugas/index', $data);
    }



    // Menampilkan list petugas dengan dataTables

    public function list_petugas()
    {
        $no = 1;

        $data = $this->Data->petugas_get();


        foreach ($data as $petugas) {
            echo '<tr>';
            echo '<td>' . $no++ . '</td>';
            echo '<td>' . $petugas->USERNAME . '</td>';
            echo '<td>**************</td>';
            echo '<td>' . $petugas->NAMA_PETUGAS . '</td>';
            echo '<td>
                <a href="#" data-toggle="modal" data-target="#modalEdit' . $petugas->ID_PETUGAS . '" class="btn btn-sm btn-warning" data-popup="tooltip" data-placement="top" title="Edit Data">Edit</a>
                <a href="' . base_url('masterdata/petugas_del/') .  $petugas->ID_PETUGAS . '" class="btn btn-sm btn-danger tombol-hapus">Hapus</a>
                </td>';
            echo '</tr>';
            echo "<script>
                     $('.tombol-hapus').on('click', function(e) {

                         e.preventDefault();

                         const href = $(this).attr('href');

                         Swal.fire({
                             title: 'Yakin ingin hapus?',
                             text: 'Data yang dihapus akan hilang!',
                             type: 'warning',
                             showCancelButton: true,
                             confirmButtonColor: '#3085d6',
                             cancelButtonColor: '#d33',
                             confirmButtonText: 'Hapus data!',
                             cancelButtonText: 'Batal'
                         }).then((result) => {
                             if (result.value) {
                                 document.location.href = href;
                             }
                         });

                     });
                 </script>";
        }
    }


    public function add_petugas()
    {
        $data['title'] = 'Data Petugas';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();

        $this->form_validation->set_rules('username', 'Username', 'required|trim|is_unique[tbl_petugas.username]', [
            'required' => 'Username tidak boleh kosong!',
            'is_unique' => 'Username sudah ada.'
        ]);
        $this->form_validation->set_rules('password1', 'Password', 'required|trim|matches[password2]|max_length[8]', [
            'required' => 'Password tidak boleh kosong!',
            'matches' => 'Password tidak sama.',
            'max_length' => 'Password hanya dapat menggunakan 8 karakter.'
        ]);
        $this->form_validation->set_rules('password2', 'Password', 'required|trim', [
            'required' => 'Password tidak boleh kosong!'
        ]);
        $this->form_validation->set_rules('nama', 'Nama', 'required|trim', [
            'required' => 'Username tidak boleh kosong!'
        ]);

        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/petugas/add', $data);
        } else {
            $this->Data->petugas_add();

         

            // Jika admin sudah menambah petugas maka masukan ke dalam log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('petugas', 'Menambah data petugas', $assign_to, $assign_type);

                $this->session->set_flashdata('message',   '<div class="alert alert-success" role"alert">Data ditambahkan</div>');
                redirect('masterdata/petugas');
            } else {
                return false;
            }
        }
    }

    public function petugas_del($id)
    {
        $this->db->trans_start();

        // cek apakah data di tabel terkait masih ada yang menggunakan nilai ID ini
        $cek = $this->db->get_where('tbl_pembayaran', ['id_petugas' => $id]);
        if ($cek->num_rows() > 0) {
            // Ada data terkait,rollback transaksi dan hentikan proses penghapusan
            $this->db->trans_rollback();
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Data tidak dapat di hapus karena sudah terpakai</div>'
            );
            redirect('masterdata/petugas');
        }

        // Tidak ada data terkait, lanjutkan dengan penghapusan data
        $this->db->delete('tbl_petugas', ['id_petugas' => $id]);

        $this->db->trans_complete();
        if ($this->db->trans_status() == false) {
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Gagal diubah</div>'
            );
            redirect('masterdata/petugas');
        } else {
            $this->session->set_flashdata(
                'message',
                '<div class="alert alert-danger" role"alert">Data berhasil dihapus</div>'
            );
            redirect('masterdata/petugas');
            // Transaksi berhasil, tampilkan pesan sukses
        }
    
        if ($this->db->affected_rows() > 0) {
            $assign_to = '';
            $assign_type = '';
            activity_log('petugas', 'Menghapus data petugas', $assign_to, $assign_type);

            $this->session->set_flashdata('success',  'dihapus');
            redirect('masterdata/petugas');
        } else {
            return false;
        }
    }

    public function petugas_edit()
    {
        $this->form_validation->set_rules('username', 'Username', 'required|trim');
        $this->form_validation->set_rules('nama', 'Nama', 'required|trim');

        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/petugas');
        } else {
            $this->Data->petugas_edit();

            // Jika admin sudah mengedit maka masukan ke dalam log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('petugas', 'Mengedit data petugas', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data diubah</div>');
                redirect('masterdata/petugas');
            } else {
                return false;
            }
        }
    }


    // Untuk merubah password petugas

    public function petugas_pass()
    {
        $this->form_validation->set_rules('password1', 'Password', 'required|trim|min_length[8]|matches[password2]');
        $this->form_validation->set_rules('password2', 'Password', 'required|trim|matches[password1]');

        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/petugas');
        } else {
            $data = [
                'password_petugas' => md5($this->input->post('password1')),
                'deskripsi' => $this->input->post('password1')
            ];

            $this->db->set($data);
            $this->db->where('id_petugas', $this->input->post('id_petugas'));
            $this->db->update('tbl_petugas');


            // Jika admin sudah mengganti password petugas maka masukan ke dalam log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('petugas', 'Merubah password petugas', $assign_to, $assign_type);

                $this->session->set_flashdata('success',  '<div class="alert alert-success" role"alert">Data diubah</div>');
                redirect('masterdata/petugas');
            } else {
                return false;
            }
        }
    }





    /*----------------------------------------------------------
    
                    CRUD untuk data siswa
    
    ----------------------------------------------------------*/






    public function siswa()
    {
        $data['title'] = 'Data Siswa';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();

      

        // var_dump($this->input->post('keyword'));die;            

        $data['siswa'] = $this->Data->siswa_get();

        if ($this->input->post('keyword') != null) {
            $data['siswa'] = $this->Data->cariDataSiswa();
        }
        $data['kelas'] = $this->db->get('tbl_kelas')->result();
        $data['spp'] = $this->db->get('tbl_spp')->result();


        $this->load->view('templates/header', $data);
        $this->load->view('templates/navbar', $data);
        $this->load->view('templates/sidebar', $data);
        $this->load->view('master/siswa/index', $data);
    }


    // menampilkan list siswa dengan dataTables


    public function list_siswa()
    {
        $no = 1;

        $data = $this->Data->siswa_get();


        foreach ($data as $siswa) {
            echo '<tr>';
            echo '<td>' . $no++ . '</td>';
            echo '<td>' . $siswa->NISN . '</td>';
            echo '<td>' . $siswa->NIS . '</td>';
            echo '<td>' . $siswa->NAMA . '</td>';
            echo '<td>' . $siswa->nama_kelas . '</td>';
            echo '<td>' . $siswa->tahun . '</td>';
            echo '<td>' . $siswa->ALAMAT . '</td>';
            echo '<td>' . $siswa->NO_TELP . '</td>';
            echo '<td>
                <a href="#" data-toggle="modal" data-target="#modalEdit' . $siswa->NISN . '" class="btn btn-sm btn-warning" data-popup="tooltip" data-placement="top" title="Edit Data">Edit</a>
                <a href="' . base_url('masterdata/siswa_del/') .  $siswa->NISN . '" class="btn btn-sm btn-danger tombol-hapus"  id="delete" name="delete">Hapus</a>
                </td>';
            echo '</tr>';
            echo "<script>
                     $('.tombol-hapus').on('click', function(e) {

                         e.preventDefault();

                         const href = $(this).attr('href');

                         Swal.fire({
                             title: 'Yakin ingin hapus?',
                             text: 'Data yang dihapus akan hilang!',
                             type: 'warning',
                             showCancelButton: true,
                             confirmButtonColor: '#3085d6',
                             cancelButtonColor: '#d33',
                             confirmButtonText: 'Hapus data!',
                             cancelButtonText: 'Batal'
                         }).then((result) => {
                             if (result.value) {
                                 document.location.href = href;
                             }
                         });

                     });
                 </script>";
        }
    }

    public function add_siswa()
    {
        $data['title'] = 'Data Siswa';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['kelas'] = $this->db->get('tbl_kelas')->result();
        $data['spp'] = $this->db->get('tbl_spp')->result();

        $this->form_validation->set_rules('NISN', 'NISN', 'required|trim|min_length[10]|max_length[10]|is_unique[tbl_siswa.NISN]', [
            'required' => 'NISN tidak boleh kosong!',
            'is_unique' => 'NISN sudah ada.'
        ]);
        $this->form_validation->set_rules('NIS', 'NIS', 'required|trim|is_unique[tbl_siswa.NIS]', [
            'required' => 'NIS tidak boleh kosong!',
            'is_unique' => 'NIS sudah ada.'
        ]);
        $this->form_validation->set_rules('nama', 'Nama', 'required|trim|is_unique[tbl_siswa.Nama]', [
            'required' => 'Nama tidak boleh kosong!',
            'is_unique' => 'Nama sudah ada.'
        ]);
        $this->form_validation->set_rules('kelas_id', 'Kelas', 'required|trim', [
            'required' => 'Kelas tidak boleh kosong!',
        ]);
        $this->form_validation->set_rules('spp_id', 'Tahun Ajaran', 'required|trim', [
            'required' => 'Tahun Ajaran tidak boleh kosong!',
        ]);
        $this->form_validation->set_rules('alamat', 'Alamat', 'required|trim', [
            'required' => 'Alamat tidak boleh kosong!',
        ]);
        $this->form_validation->set_rules('no_telp', 'No.Telp', 'required|trim', [
            'required' => 'No.Telp tidak boleh kosong!',
        ]);
        $this->form_validation->set_rules('tempo', 'Jatuh Tempo', 'required', [
            'required' => 'Tempo tidak boleh kosong!',
        ]);

        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/siswa/add', $data);
        } else {

            $spp = $this->Data->get_id_spp();

            foreach ($spp as $s) : endforeach;

            $this->Data->siswa_add($s->NOMINAL);

            // Jika admin atau petugas menambahkan siswa maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('siswa', 'Menambah data siswa', $assign_to, $assign_type);

                $this->session->set_flashdata('message',   '<div class="alert alert-success" role"alert">Data ditambahkan</div>');
                redirect('masterdata/siswa');
            } else {
                return false;
            }
        }
    }
    public function siswa_del($id)
    {
        $this->db->trans_start();

        // cek apakah data di tabel terkait masih ada yang menggunakan nilai ID ini
        $cek = $this->db->get_where('tbl_pembayaran', ['NISN' => $id]);
        if ($cek->num_rows() > 0) {
            // Ada data terkait,rollback transaksi dan hentikan proses penghapusan
            $this->db->trans_rollback();
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Data tidak dapat di hapus karena sudah terpakai</div>'
            );
            redirect('masterdata/siswa');
        }

        // Tidak ada data terkait, lanjutkan dengan penghapusan data
        $this->db->delete('tbl_siswa', ['NISN' => $id]);

        $this->db->trans_complete();
        if ($this->db->trans_status() == false) {
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Gagal diubah</div>'
            );
            redirect('masterdata/siswa');
        } else {
            $this->session->set_flashdata(
                'message',
                '<div class="alert alert-danger" role"alert">Data berhasil dihapus</div>'
            );
            redirect('masterdata/siswa');
            // Transaksi berhasil, tampilkan pesan sukses
        }
    


        if ($this->db->affected_rows() > 0) {
            $assign_to = '';
            $assign_type = '';
            activity_log('siswa', 'Menghapus data siswa', $assign_to, $assign_type);

            

            $this->session->set_flashdata('success',  'dihapus');
            redirect('masterdata/siswa');
        } else {
            return false;
        }
    }

    public function siswa_edit()
    {
     
        $this->form_validation->set_rules('NIS', 'NIS', 'required|trim');
        $this->form_validation->set_rules('nama', 'Nama', 'required|trim');
        $this->form_validation->set_rules('kelas_id', 'Kelas', 'required|trim');
        $this->form_validation->set_rules('spp_id', 'Tahun Ajaran', 'required|trim');
        $this->form_validation->set_rules('alamat', 'Alamat', 'required|trim');
        $this->form_validation->set_rules('no_telp', 'No.Telp', 'required|trim');

        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/siswa');
        } else {
            $this->Data->siswa_edit();

            // Jika admin atau petugas mengedit siswa maka akan masuk ke log activity


            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('siswa', 'Mengedit data siswa', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data diubah</div>');

                redirect('masterdata/siswa');
            } else {
                return false;
            }
        }
    }





    /*------------------------------------------------------
    
                    CRUD untuk data SPP
    
    ------------------------------------------------------*/








    public function spp()
    {
        $data['title'] = 'Data SPP';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['spp'] = $this->db->get('tbl_spp')->result();


        $this->load->view('templates/header', $data);
        $this->load->view('templates/navbar', $data);
        $this->load->view('templates/sidebar', $data);
        $this->load->view('master/spp/index', $data);
    }


    // menampilkan list spp dengan dataTables


    public function list_spp()
    {
        $no = 1;

        $data = $this->db->get('tbl_spp')->result();


        foreach ($data as $spp) {
            echo '<tr>';
            echo '<td>' . $no++ . '</td>';
            echo '<td>' . $spp->TAHUN . '</td>';
            echo '<td> Rp.' . $spp->NOMINAL . '</td>';
            echo '<td>
                <a href="#" data-toggle="modal" data-target="#modalEdit' . $spp->ID_SPP . '" class="btn btn-sm btn-warning" data-popup="tooltip" data-placement="top" title="Edit Data">Edit</a>
                <a href="' . base_url('masterdata/spp_del/') .  $spp->ID_SPP . '" class="btn btn-sm btn-danger tombol-hapus"  id="delete" name="delete">Hapus</a>
                </td>';
            echo '</tr>';
             echo "<script>
                     $('.tombol-hapus').on('click', function(e) {

                         e.preventDefault();

                         const href = $(this).attr('href');

                         Swal.fire({
                             title: 'Yakin ingin hapus?',
                             text: 'Data yang dihapus akan hilang!',
                             type: 'warning',
                             showCancelButton: true,
                             confirmButtonColor: '#3085d6',
                             cancelButtonColor: '#d33',
                             confirmButtonText: 'Hapus data!',
                             cancelButtonText: 'Batal'
                         }).then((result) => {
                             if (result.value) {
                                 document.location.href = href;
                             }
                         });

                     });
                 </script>";
        }
    }

    public function add_spp()
    {
        $data['title'] = 'Data SPP';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['spp'] = $this->db->get('tbl_spp')->result();

        $this->form_validation->set_rules('tahun_awal', 'Tahun Awal', 'required', [
            'required' => 'Tahun Pertama tidak boleh kosong!'
        ]);
        $this->form_validation->set_rules('tahun_akhir', 'Tahun Akhir', 'required', [
            'required' => 'Tahun Kedua tidak boleh kosong!'
        ]);
        $this->form_validation->set_rules('nominal', 'Nominal', 'required', [
            'required' => 'Nominal tidak boleh kosong!'
        ]);

        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/spp/add', $data);
        } else {
            $data = [
                'tahun' => $this->input->post('tahun_awal') . '/' . $this->input->post('tahun_akhir'),
                'nominal' => $this->input->post('nominal')
            ];

            $this->db->insert('tbl_spp', $data);

            // Jika admin atau petugas menambahkan data spp maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('spp', 'Menambah data spp', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data berhasil ditambahkan</div>');

                redirect('masterdata/spp');
            } else {
                return false;
            }
        }
    }

    public function spp_del($id)
    {
        $this->db->trans_start();

        // cek apakah data di tabel terkait masih ada yang menggunakan nilai ID ini
        $cek = $this->db->get_where('tbl_pembayaran', ['id_spp' => $id]);
        if ($cek->num_rows() > 0) {
            // Ada data terkait,rollback transaksi dan hentikan proses penghapusan
            $this->db->trans_rollback();
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Data tidak dapat di hapus karena sudah terpakai</div>'
            );
            redirect('masterdata/spp');
        }

        // Tidak ada data terkait, lanjutkan dengan penghapusan data
        $this->db->delete('tbl_spp', ['id_spp' => $id]);

        $this->db->trans_complete();
        if ($this->db->trans_status() == false) {
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Gagal diubah</div>'
            );
            redirect('masterdata/spp');
        } else {
            $this->session->set_flashdata(
                'message',
                '<div class="alert alert-danger" role"alert">Data berhasil dihapus</div>'
            );
            redirect('masterdata/spp');
            // Transaksi berhasil, tampilkan pesan sukses
        }
    
        if ($this->db->affected_rows() > 0) {
            $assign_to = '';
            $assign_type = '';
            activity_log('spp', 'Menghapus data spp', $assign_to, $assign_type);

            $this->session->set_flashdata('success',  'dihapus');
            redirect('masterdata/spp');
        } else {
            return false;
        }
    }

    public function spp_edit()
    {
        $this->form_validation->set_rules('tahun_awal', 'tahun_awal', 'required|trim');
        $this->form_validation->set_rules('nominal', 'nominal', 'required|trim');

        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/spp');
        } else {
            $this->Data->spp_edit();

            // Jika admin atau petugas mengedit data spp maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('spp', 'Mengedit data spp', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data diubah</div>');

                redirect('masterdata/spp');
            } else {
                return false;
            }
        }
    }





    /*---------------------------------------------------------------

            CRUD untuk data kelas

    ---------------------------------------------------------------- */








    public function kelas()
    {
        $data['title'] = 'Data Kelas';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['kelas'] = $this->Data->kelas_get();
        $data['jurusan'] = $this->db->get('tbl_jurusan')->result();


        $this->load->view('templates/header', $data);
        $this->load->view('templates/navbar', $data);
        $this->load->view('templates/sidebar', $data);
        $this->load->view('master/kelas/index', $data);
    }


    // menampilkan list kelas dengan dataTables



    public function list_kelas()
    {
        $no = 1;

        $data = $this->Data->kelas_get();


        foreach ($data as $kelas) {
            echo '<tr>';
            echo '<td>' . $no++ . '</td>';
            echo '<td>' . $kelas->NAMA_KELAS . '</td>';
            echo '<td>' . $kelas->jurusan . '</td>';
            echo '<td>
                <a href="#" data-toggle="modal" data-target="#modalEdit' . $kelas->ID_KELAS . '" class="btn btn-sm btn-warning" data-popup="tooltip" data-placement="top" title="Edit Data">Edit</a>
                <a href="' . base_url('masterdata/kelas_del/') .  $kelas->ID_KELAS . '" class="btn btn-sm btn-danger tombol-hapus"  id="delete" name="delete">Hapus</a>
                </td>';
            echo '</tr>';
            echo "<script>
                     $('.tombol-hapus').on('click', function(e) {

                         e.preventDefault();

                         const href = $(this).attr('href');

                         Swal.fire({
                             title: 'Yakin ingin hapus?',
                             text: 'Data yang dihapus akan hilang!',
                             type: 'warning',
                             showCancelButton: true,
                             confirmButtonColor: '#3085d6',
                             cancelButtonColor: '#d33',
                             confirmButtonText: 'Hapus data!',
                             cancelButtonText: 'Batal'
                         }).then((result) => {
                             if (result.value) {
                                 document.location.href = href;
                             }
                         });

                     });
                 </script>";
        }
    }


    public function add_kelas()
    {
        $data['title'] = 'Data Kelas';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['kelas'] = $this->Data->kelas_get();
        $data['jurusan'] = $this->db->get('tbl_jurusan')->result();

        $this->form_validation->set_rules('nama_kelas', 'Kelas', 'required', [
            'required' => 'Kelas tidak boleh kosong.'
        ]);
        $this->form_validation->set_rules('jurusan', 'Jurusan', 'required', [
            'required' => 'Kompetensi Keahlian tidak boleh kosong.'
        ]);


        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/kelas/add', $data);
        } else {
            $this->Data->kelas_add();

            // Jika admin atau petugas menambahkan data kelas maka akan masuk ke log activity


            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('kelas', 'Menambah data kelas', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data berhasil ditambahkan</div>');
                redirect('masterdata/kelas');
            } else {
                return false;
            }
        }
    }

    public function kelas_del($id)
    {
        $this->db->trans_start();

        // cek apakah data di tabel terkait masih ada yang menggunakan nilai ID ini
        $cek = $this->db->get_where('tbl_siswa', ['id_kelas' => $id]);
        if ($cek->num_rows() > 0) {
            // Ada data terkait,rollback transaksi dan hentikan proses penghapusan
            $this->db->trans_rollback();
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Data tidak dapat di hapus karena sudah terpakai</div>'
            );
            redirect('masterdata/kelas');
        }

        // Tidak ada data terkait, lanjutkan dengan penghapusan data
        $this->db->delete('tbl_kelas', ['id_kelas' => $id]);

        $this->db->trans_complete();
        if ($this->db->trans_status() == false) {
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Gagal diubah</div>'
            );
            redirect('masterdata/kelas');
        } else {
            $this->session->set_flashdata(
                'message',
                '<div class="alert alert-danger" role"alert">Data berhasil dihapus</div>'
            );
            redirect('masterdata/kelas');
            // Transaksi berhasil, tampilkan pesan sukses
        }
    

        if ($this->db->affected_rows() > 0) {
            $assign_to = '';
            $assign_type = '';
            activity_log('kelas', 'Menghapus data kelas', $assign_to, $assign_type);

            $this->session->set_flashdata('success',  'dihapus');
            redirect('masterdata/kelas');
        } else {
            return false;
        }
    }

    public function kelas_edit()
    {
        $this->form_validation->set_rules('nama_kelas', 'Kelas', 'required');
        $this->form_validation->set_rules('jurusan', 'Jurusan', 'required');


        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/kelas');
        } else {
            $this->Data->kelas_edit();

            // Jika admin atau petugas mengedit data kelas maka akan masuk ke log activity


            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('kelas', 'Mengedit data kelas', $assign_to, $assign_type);

                $this->session->set_flashdata('message',  '<div class="alert alert-success" role"alert">Data diubah</div>');

                
                redirect('masterdata/kelas');
            } else {
                return false;
            }
        }
    }





    /*--------------------------------------------------------
    
                CRUD untuk data Jurusan

    ---------------------------------------------------------*/








    public function jurusan()
    {
        $data['title'] = 'Data Jurusan';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['jurusan'] = $this->db->get('tbl_jurusan')->result();


        $this->form_validation->set_rules('jurusan', 'Jurusan', 'required', [
            'required' => 'Kompetensi Keahlian tidak boleh kosong.'
        ]);


        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/jurusan/index', $data);
        } else {
            $this->db->insert('tbl_jurusan', ['jurusan' => $this->input->post('jurusan')]);

            // Jika admin atau petugas menambahkan data jurusan maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('jurusan', 'Menambah data jurusan', $assign_to, $assign_type);

                $this->session->set_flashdata('success',  'ditambahkan');
                redirect('masterdata/jurusan');
            } else {
                return false;
            }
        }
    }




    public function add_jurusan()
    {
        $data['title'] = 'Data Jurusan';
        $data['user'] = $this->db->get_where('tbl_petugas', ['username' => $this->session->userdata('username')])->row_array();
        $data['siswa'] = $this->db->get_where('tbl_siswa', ['nisn' => $this->session->userdata('NISN')])->row_array();
        $data['jurusan'] = $this->db->get('tbl_jurusan')->result();


        $this->form_validation->set_rules('jurusan', 'Jurusan', 'required', [
            'required' => 'Kompetensi Keahlian tidak boleh kosong.'
        ]);


        if ($this->form_validation->run() == false) {
            $this->load->view('templates/header', $data);
            $this->load->view('templates/navbar', $data);
            $this->load->view('templates/sidebar', $data);
            $this->load->view('master/jurusan/tambah', $data);
        } else {
            $this->db->insert('tbl_jurusan', ['jurusan' => $this->input->post('jurusan')]);

            // Jika admin atau petugas menambahkan data jurusan maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('jurusan', 'Menambah data jurusan', $assign_to, $assign_type);

                $this->session->set_flashdata('success',  'ditambahkan');
                redirect('masterdata/jurusan');
            } else {
                return false;
            }
        }
    }


    public function list_jurusan()
    {
        $no = 1;

        $data = $this->db->get('tbl_jurusan')->result();


        foreach ($data as $jurusan) {
            echo '<tr>';
            echo '<td>' . $no++ . '</td>';
            echo '<td>' . $jurusan->JURUSAN . '</td>';
            echo '<td>
                <a href="#" data-toggle="modal" data-target="#modalEdit' . $jurusan->ID_JURUSAN . '" class="btn btn-sm btn-warning" data-popup="tooltip" data-placement="top" title="Edit Data">Edit</a>
                <a href="' . base_url('masterdata/jurusan_del/') .  $jurusan->ID_JURUSAN . '" class="btn btn-sm btn-danger tombol-hapus"  id="delete" name="delete">Hapus</a>
                </td>';
            echo '</tr>';
            echo "<script>
                     $('.tombol-hapus').on('click', function(e) {

                         e.preventDefault();

                         const href = $(this).attr('href');

                         Swal.fire({
                             title: 'Yakin ingin hapus?',
                             text: 'Data yang dihapus akan hilang!',
                             type: 'warning',
                             showCancelButton: true,
                             confirmButtonColor: '#3085d6',
                             cancelButtonColor: '#d33',
                             confirmButtonText: 'Hapus data!',
                             cancelButtonText: 'Batal'
                         }).then((result) => {
                             if (result.value) {
                                 document.location.href = href;
                             }
                         });

                     });
                 </script>";
        }
    }

    public function jurusan_del($id)
    {
        $this->db->trans_start();

        // cek apakah data di tabel terkait masih ada yang menggunakan nilai ID ini
        $cek = $this->db->get_where('tbl_pembayaran', ['id_jurusan' => $id]);
        if ($cek->num_rows() > 0) {
            // Ada data terkait,rollback transaksi dan hentikan proses penghapusan
            $this->db->trans_rollback();
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Data tidak dapat di hapus karena sudah terpakai</div>'
            );
            redirect('masterdata/jurusan');
        }

        // Tidak ada data terkait, lanjutkan dengan penghapusan data
        $this->db->delete('tbl_jurusan', ['id_jurusan' => $id]);

        $this->db->trans_complete();
        if ($this->db->trans_status() == false) {
            $this->session->set_flashdata(
                'info',
                '<div class="alert alert-danger" role"alert">Gagal diubah</div>'
            );
            redirect('masterdata/jurusan');
        } else {
            $this->session->set_flashdata(
                'message',
                '<div class="alert alert-danger" role"alert">Data berhasil dihapus</div>'
            );
            redirect('masterdata/jurusan');
            // Transaksi berhasil, tampilkan pesan sukses
        }
    
        if ($this->db->affected_rows() > 0) {
            $assign_to = '';
            $assign_type = '';
            activity_log('jurusan', 'Menghapus data jurusan', $assign_to, $assign_type);

            $this->session->set_flashdata('success',  'dihapus');
            redirect('masterdata/jurusan');
        } else {
            return false;
        }
    }

    public function jurusan_edit()
    {
        $this->form_validation->set_rules('jurusan', 'Jurusan', 'required');


        if ($this->form_validation->run() == false) {
            $this->session->set_flashdata('gagal', 'diubah');
            redirect('masterdata/jurusan');
        } else {
            $this->db->set(['jurusan' => $this->input->post('jurusan')]);
            $this->db->where('id_jurusan', $this->input->post('id_jurusan'));
            $this->db->update('tbl_jurusan');

            // Jika admin atau petugas mengedit data jurusan maka akan masuk ke log activity

            if ($this->db->affected_rows() > 0) {
                $assign_to = '';
                $assign_type = '';
                activity_log('jurusan', 'Mengedit data jurusan', $assign_to, $assign_type);

                $this->session->set_flashdata('success',  '<div class="alert alert-success" role"alert">Data diubah</div>');

                $this->session->set_flashdata('success',  'diubah');
                redirect('masterdata/jurusan');
            } else {
                return false;
            }
        }
    }
}

