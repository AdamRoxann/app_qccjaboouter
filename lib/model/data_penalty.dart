class DataPenalty {
  final int id;
  final int id_tiket;
  final String siteid;
  final String kondisi_site;
  final String jenis_recon_v1;
  final String tgl_close;
  final int estimasidenda_original;
  final String created_at;

  // final String tgl_close_user;

  DataPenalty(
    this.id,
    this.id_tiket,
    this.siteid,
    this.kondisi_site,
    this.jenis_recon_v1,
    this.tgl_close,
    this.estimasidenda_original,
    this.created_at,
  );
}
