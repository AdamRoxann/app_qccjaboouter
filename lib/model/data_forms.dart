class DataForms {
  final int id;
  final int id_tiket;
  final String siteid;
  final String kondisi_site;
  final String jenis_recon_v1;
  final String tgl_request;
  final String tgl_close;
  final String tanggalclose_afterrecon;
  final int estimasidenda_original;
  final String created_at;

  // final String tgl_close_user;

  DataForms(
    this.id,
    this.id_tiket,
    this.siteid,
    this.kondisi_site,
    this.jenis_recon_v1,
    this.tgl_request,
    this.tgl_close,
    this.tanggalclose_afterrecon,
    this.estimasidenda_original,
    this.created_at,
  );
}

class DataFormsView {
  final int id;
  final int id_tiket;
  final String siteid;
  final String kondisi_site;
  final String jenis_recon_v1;
  final String tgl_request;
  final String tgl_close;
  final String tanggalclose_afterrecon;
  final int estimasidenda_original;
  final String status_recon_v2;
  final String alasan_submitrecon;
  final String kondisisite_afterrecon_v1;
  final String solusi;
  final String created_at;

  // final String tgl_close_user;

  DataFormsView(
    this.id,
    this.id_tiket,
    this.siteid,
    this.kondisi_site,
    this.jenis_recon_v1,
    this.tgl_request,
    this.tgl_close,
    this.tanggalclose_afterrecon,
    this.estimasidenda_original,
    this.status_recon_v2,
    this.alasan_submitrecon,
    this.kondisisite_afterrecon_v1,
    this.solusi,
    this.created_at,
  );
}

class ImageModel {
  final int id;
  final String image_name1;
  final String image_name2;
  final String image_name3;
  final String image_name4;
  final String image_name5;
  final String image_name6;
  final String created_at;

  // final String tgl_close_user;

  ImageModel(
    this.id,
    this.image_name1,
    this.image_name2,
    this.image_name3,
    this.image_name4,
    this.image_name5,
    this.image_name6,
    this.created_at,
  );
}
