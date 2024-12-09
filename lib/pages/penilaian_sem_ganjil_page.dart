import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/jadwal-pelajaran/jadwal_pelajaran_model.dart';
import '../../../../../models/user_model.dart';
import '../../../../../providers/auth_provider.dart';
import '../../../../../providers/nilai/nilai_siswa_provider.dart';
import '../../../../../providers/siswa_provider.dart';
import '../../../../../theme/theme.dart';
import '../models/nilai_siswa_model.dart';
import '../providers/nilai_siswa_provider.dart';

class PenilaianSemGanjilPage extends StatefulWidget {
  final KelasModel kelas;
  final JadwalPelajaranModel jadwal;
  const PenilaianSemGanjilPage({super.key, required this.kelas, required this.jadwal});

  @override
  State<PenilaianSemGanjilPage> createState() => _PenilaianSemGanjilPageState();
}

class _PenilaianSemGanjilPageState extends State<PenilaianSemGanjilPage> {
  late AuthProvider authProvider;
  late UserModel user;
  late SiswaProvider siswaProvider;
  late NilaiSiswaByUserProvider nilaiSiswaProvider;
  String? token;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      user = authProvider.user;
      siswaProvider = Provider.of<SiswaProvider>(context, listen: false);
      nilaiSiswaProvider = Provider.of<NilaiSiswaByUserProvider>(context, listen: false);
      token = authProvider.user.token;

      // Fetch data
      siswaProvider.fetchSiswa(widget.kelas.id, token!);
      nilaiSiswaProvider.nilaiSiswaByKelasPelajaran(token!, widget.kelas.id, widget.jadwal.mataPelajaran.id);
    });
  }

  void addNilaiDialog(BuildContext context, UserModel siswa, NilaiSiswaByUserModel nilai) {
    TextEditingController nilaiController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Input Nilai Siswa",
      titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: nilaiController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Masukkan Nilai',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nilai harus diisi';
              }
              return null;
            },
          ),
        ),
      ),
      btnOkText: 'Nilai',
      btnCancelOnPress: (){},
      btnOkOnPress: () async {
        if (formKey.currentState!.validate()) {
          try {
            double? nilai = double.tryParse(nilaiController.text);
            if (nilai != null) {
              // Use the double value
              await nilaiSiswaProvider.addNilaiSiswa(
                  token!,
                  siswa.id,
                  widget.kelas.id,
                  1,
                  widget.jadwal.mataPelajaran.id,
                  user.id,
                  nilai
              );

              if (token != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false, // Prevent dismissing by tapping outside
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator( color: tSecondaryColor,),
                          const SizedBox(width: 20),
                          Text("Loading...", style: secondaryTextStyle,),
                        ],
                      ),
                    );
                  },
                );

                // Perform the await operation
                await nilaiSiswaProvider.nilaiSiswaByKelasPelajaran(
                  token!,
                  widget.kelas.id,
                  widget.jadwal.mataPelajaran.id,
                );

                // Dismiss the loading dialog
                Navigator.of(context).pop();
              } else {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Sesi Anda Habis",
                    titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
                    desc: "Sesi Anda habis, silahkan login lagi",
                    descTextStyle: darkGreenTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                    btnOkOnPress: () async{
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    }
                ).show();
              }

              AwesomeDialog successDialog = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: 'Berhasil!',
                  desc: 'Berhasil melakukan penilaian.',
                  btnOkOnPress: (){}
              );

              successDialog.show();
            } else {
              // You can also show a dialog or a message to the user here
              AwesomeDialog failedDialog = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.topSlide,
                  title: 'Gagal!',
                  desc: 'Format nilai salah',
                  btnOkOnPress: (){}
              );

              failedDialog.show();
            }
          } catch (e) {
            AwesomeDialog failedDialog = AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                title: 'Gagal!',
                desc: 'Gagal memberikan nilai',
                btnOkOnPress: (){}
            );

            failedDialog.show();
          }
        } else {
          AwesomeDialog failedDialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            title: 'Gagal!',
            desc: 'Nilai tidak boleh kosong',
            btnOkOnPress: (){}
          );

          failedDialog.show();

          // Future.delayed(const Duration(seconds: 3), () {
          //   failedDialog.dismiss();
          // });
        }
      },
    ).show();
  }

  void updateNilaiDialog(BuildContext context, UserModel siswa, NilaiSiswaByUserModel nilai) {
    TextEditingController nilaiController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Update Nilai Siswa",
      titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: nilaiController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Masukkan Nilai',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nilai harus diisi';
              }
              return null;
            },
          ),
        ),
      ),
      btnOkText: 'Update',
      btnCancelOnPress: (){},
      btnOkOnPress: () async {
        if (formKey.currentState!.validate()) {
          try {
            double? nilaiInput = double.tryParse(nilaiController.text);
            if (nilaiInput != null) {
              // Use the double value
              await nilaiSiswaProvider.updateNilaiSiswa(
                  token!,
                  nilai.id,
                  user.id,
                  nilaiInput
              );
            } else {
              // Handle the case where the conversion failed
              AwesomeDialog failedDialog = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: 'Gagal!',
                  desc: 'Gagal melakukan update nilai, nilsi tidsk boleh kosong.',
                  btnOkOnPress: (){}
              );

              failedDialog.show();
              // You can also show a dialog or a message to the user here
            }

            if (token != null) {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing by tapping outside
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator( color: tSecondaryColor,),
                        const SizedBox(width: 20),
                        Text("Loading...", style: secondaryTextStyle,),
                      ],
                    ),
                  );
                },
              );

              // Perform the await operation
              await nilaiSiswaProvider.nilaiSiswaByKelasPelajaran(
                token!,
                widget.kelas.id,
                widget.jadwal.mataPelajaran.id,
              );

              // Dismiss the loading dialog
              Navigator.of(context).pop();
            } else {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: "Sesi Anda Habis",
                  titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
                  desc: "Sesi Anda habis, silahkan login lagi",
                  descTextStyle: darkGreenTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                  btnOkOnPress: () async{
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  }
              ).show();
            }

            AwesomeDialog successDialog = AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.topSlide,
              showCloseIcon: true,
              title: 'Berhasil!',
              desc: 'Berhasil melakukan update nilai.',
              btnOkOnPress: (){}
            );

            successDialog.show();

            // Future.delayed(const Duration(seconds: 2), () {
            //   successDialog.dismiss();
            // });


          } catch (e) {
            AwesomeDialog failedDialog = AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: 'Gagal!',
                desc: 'Gagal melakukan update nilai.',
                btnOkOnPress: (){}
            );

            failedDialog.show();
          }
        } else {
          AwesomeDialog failedDialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            title: 'Gagal!',
            desc: 'Nilai tidak boleh kosong',
            btnOkOnPress: (){}
          );

          failedDialog.show();

          // Future.delayed(const Duration(seconds: 3), () {
          //   failedDialog.dismiss();
          // });
        }
      },
    ).show();
  }

  void actionDialog(BuildContext context, UserModel siswa, NilaiSiswaByUserModel nilai) {

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Pilih Aksi",
      titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
      desc: 'Pilih aksi yang ingin dilakukan',
      btnOkText: 'Update',
      btnCancelText: 'Delete',
      btnCancelOnPress: (){
        AwesomeDialog deleteDialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            title: 'Hapus Nilai',
            desc: 'Apakah Anda yakin ingin menghapus nilai ${siswa.name}',
            btnCancelOnPress: (){},
            btnOkOnPress: ()async{
              try {
                await nilaiSiswaProvider.deleteNilaiSiswa(
                    token!,
                    nilai.id,
                );

                if (token != null) {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent dismissing by tapping outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator( color: tSecondaryColor,),
                            const SizedBox(width: 20),
                            Text("Loading...", style: secondaryTextStyle,),
                          ],
                        ),
                      );
                    },
                  );

                  // Perform the await operation
                  await nilaiSiswaProvider.nilaiSiswaByKelasPelajaran(
                    token!,
                    widget.kelas.id,
                    widget.jadwal.mataPelajaran.id,
                  );

                  // Dismiss the loading dialog
                  Navigator.of(context).pop();

                  // Show success dialog
                  AwesomeDialog successDialog = AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: 'Hapus nilai berhasil!',
                    desc: 'Berhasil menghapus nilai.',
                    btnOkOnPress: () {},
                  );

                  successDialog.show();
                } else {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Sesi Anda Habis",
                      titleTextStyle: darkGreenTextStyle.copyWith(fontSize: 24, fontWeight: bold),
                      desc: "Sesi Anda habis, silahkan login lagi",
                      descTextStyle: darkGreenTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                      btnOkOnPress: () async{
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      }
                  ).show();
                }



                // Future.delayed(const Duration(seconds: 2), () {
                //   successDialog.dismiss();
                // });


              } catch (e) {
                AwesomeDialog failedDialog = AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: 'Gagal Hapus!',
                    desc: 'Gagal menghapus nilai siswa.',
                    btnOkOnPress: (){}
                );

                failedDialog.show();
              }
            }
        );

        deleteDialog.show();
      },
      btnOkOnPress: () {
        updateNilaiDialog(context, siswa, nilai);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundPage(),
        RefreshIndicator(
          onRefresh: () async {
            // Refresh logic
            siswaProvider.fetchSiswa(widget.kelas.id, token!);
            nilaiSiswaProvider.nilaiSiswaByKelasPelajaran(token!, widget.kelas.id, widget.jadwal.mataPelajaran.id);
          },
          child: Consumer2<SiswaProvider, NilaiSiswaByUserProvider>(
            builder: (context, siswaProvider, nilaiSiswaProvider, _) {
              if (siswaProvider.isLoading || nilaiSiswaProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (siswaProvider.data == null || siswaProvider.data!.isEmpty) {
                return const Center(child: Text("Tidak ada siswa"));
              }

              // Filter nilaiSiswaByUserList to only include nilai with semester == 1
              var filteredNilaiSiswa = nilaiSiswaProvider.nilaiSiswaByUserList?.where(
                    (n) => n.semester!.semester == 1,
              ).toList() ?? [];

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          "Penilaian Kelas ${widget.kelas.nomorKelas.nomorKelas} ${widget.kelas.tipeKelas?.tipe_kelas ?? ''} Semester Ganjil",
                          style: secondaryTextStyle,
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0), // Adjust the padding as needed
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          var siswa = siswaProvider.data![index];
                          var nilai = filteredNilaiSiswa.firstWhere(
                                (n) => n.user?.id == siswa.id, // Adjust as per your model
                            orElse: () => NilaiSiswaByUserModel(
                              id: 0,
                              user: null,
                              semester: null,
                              mataPelajaran: null,
                              guruPengampu: null,
                              kelas: null,
                              idKelas: 0,
                              nilai: 0,
                            ), // Default score if not found
                          );

                          // Check if this is the last item
                          bool isLastItem = index == siswaProvider.data!.length - 1;

                          void showDialogBasedOnNilai() {
                            if (nilai.id == 0) {
                              addNilaiDialog(context, siswa, nilai);
                            } else {
                              actionDialog(context, siswa, nilai);
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: isLastItem ? 30 : 0), // Add margin to the last item
                            child: PenilaianSiswaTail(
                              nilai: nilai,
                              user: siswa,
                              onTap: showDialogBasedOnNilai
                            ),
                          );
                        },
                        childCount: siswaProvider.data!.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
