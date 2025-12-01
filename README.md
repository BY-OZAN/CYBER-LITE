# 💻 CYBER LITE :: PROFESSIONAL SYSTEM DIAGNOSTIC

CYBER LITE, bir Windows Batch betiği (`.bat`) kullanarak **profesyonel bir sistem teşhisi** gerçekleştiren hafif ve hızlı bir araçtır. Komut satırı arayüzünde (CLI) **CPU, RAM, GPU, Depolama (C:) ve Anakart/BIOS** bilgilerini özetler ve gerçek zamanlı yük/kullanım çubukları görüntüler.

## ✨ Özellikler

* **Detaylı Sistem Bilgisi:** İşlemci Adı, Çekirdek/İş Parçacığı Sayısı, Önbellek Boyutları (L2/L3), Bellek Hızı, Disk Türü ve daha fazlasını gösterir.
* **Kullanım Çubukları:** CPU Yükü, RAM Kullanımı ve C: Sürücüsü Kullanımı için görselleştirilmiş ilerleme çubukları (`█` ve `░`).
* **Yönetici Yetkisi Kontrolü:** Betik, doğru veri toplanmasını sağlamak için başlangıçta otomatik olarak yönetici yetkisi ister.
* **Yenileme Özelliği:** Görüntülenen verileri güncellemek için kolay bir **[R] Yenile** seçeneği sunar.

## 🚀 Kurulum ve Çalıştırma

CYBER LITE'ı çalıştırmak son derece basittir, ek kurulum gerektirmez.

1.  **İndirme:** `CYBER LITE.bat` dosyasını bilgisayarınıza indirin.
2.  **Çalıştırma:** Dosyaya **çift tıklayın**.
3.  **Yönetici İzni:** Windows, betiğin doğru çalışması için yönetici izni isteyecektir. İzni onaylayın.

Betik hemen çalışmaya başlayacak, sistem verilerini toplayacak ve sonucu ekranda gösterecektir.

## 🖥️ Görüntülenen Bilgiler

Betiğin topladığı ve özetlediği temel donanım ve işletim sistemi bilgileri:

| Kategori | Örnek Veri Noktaları |
| :--- | :--- |
| **CPU (İşlemci)** | Model Adı, Çekirdek/İş Parçacığı Sayısı, Güncel Yük (%) |
| **RAM (Bellek)** | Toplam/Kullanılan/Boş Bellek (MB), Hız (MHz), Üretici |
| **GPU (Ekran Kartı)** | Grafik Kartı Adı, Video Belleği (GB) |
| **DISK (Depolama)** | Toplam Kapasite/Kullanılan/Boş Alan (GB), Disk Türü |
| **SYSTEM (Platform)** | Anakart Üreticisi/Modeli, BIOS Sürümü, İşletim Sistemi Adı ve Sürümü, Sistem Çalışma Süresi |

## 🛠️ Teknik Detaylar (Geliştiriciler İçin)

* Betiğin büyük bir kısmı, detaylı ve güncel sistem bilgilerini almak için **PowerShell** komutlarını kullanır.
* `Get-CimInstance`, `Get-Volume`, `Get-PhysicalDisk` gibi cmdlet'ler donanım verilerini sorgular.
* **Veri Çubukları:** İlerleme çubukları, Windows Batch'in yerel döngüleri (`for /L`) ve gecikmeli değişken genişletme (`setlocal EnableDelayedExpansion`) kullanılarak oluşturulur.
* Kod, Türkçe karakter desteği için `chcp 65001` (UTF-8) kullanır.

## 📝 Lisans


Bu proje **MIT Lisansı** ile lisanslanmıştır. Daha fazla ayrıntı için `LICENSE` dosyasına bakınız .
