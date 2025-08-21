# AWS VPN
AWS VPN（Virtual Private Network）はオンプレミスなどのユーザー環境からAWSへ、インターネットVPN（※）でセキュアに接続するサービス。  
AWS VPNではインターネット回線を利用するので、専用回線を敷設するDirect Connectよりも安価に、かつ短い期間で接続を開始できる。

※ インターネットVPN … インターネット回線を使って拠点同士を仮想の専用線で接続し、暗号化通信を行う技術のこと。

## AWS Client VPN
AWS Client VPNは、パソコンなどの端末とVPCのClient VPNエンドポイントを、インターネットVPNで接続するサービス。  
OpenVPNというVPNソフトウェアを利用しており、Windows、macOSだけでなくiOSやAndroidにも対応している。Client VPNは機器の導入等が不要なので、手軽にセキュアな通信でAWSへアクセスできる。

## AWS Site-to-Site VPN
AWS Site-to-Site VPN（サイト間VPN）は、カスタマーゲートウェイ（オンプレミスのルーター）とVPCの仮想プライベートゲートウェイを、インターネットVPNで接続するサービス。  
Site-to-Site VPNはインターネット上に仮想の専用線であるVPNトンネルを張り、IPsecという暗号技術を使って通信を保護する。

