# Amazon Redshift
Amazon Redshiftは、ペタバイト級のストレージに対応したデータウェアハウスです。  
→ DWHでは、基本的にデータの削除・更新は行わずに追加（蓄積）されていきますので通常のデータベースよりも多くの容量が必要になります。　　

超並列処理 （MPP）機能（大量のリクエストを分散させ、並列で処理する）により、大量のデータを高速で処理することが可能です。また、列志向データベースの構造により大容量のデータを蓄積していても、高速なパフォーマンスを維持したまま集計処理などができます。

※ データウェアハウス（DWH：Data WareHouse）とは？  
複数のシステムからデータを収集・統合・蓄積し、分析に使用するデータベースです。  
蓄積したデータは、例えば時系列や顧客のデータに基づいて分析され、結果はシステム効率化や経営改善などの意思決定に利用されます。このように、大容量データを分析し経営に役立てることを「BI：Business Intelligence」といい、RedshiftはBIの分野で活用されています。

## Amazon Redshift Serverless
Amazon Redshift Serverlessは、データウェアハウスのインフラ管理を不要にするサービスです。  
クラスターのノード管理やスケーリングはAWSが自動的に行うため、インフラの運用負荷を最小限に抑えて迅速にデータ分析を始められます。クエリ実行などの実際の使用量に基づいて課金されるため、需要の予測が難しい環境でもコストを最適化できます。

## Amazon Redshift Spectrum
旧来のRedshiftでは、データが蓄積され大容量化するとS3にあるデータをRedshiftへロードする際に時間がかかっていました。この問題を解決したのがRedshift Spectrumです。  

Redshift Spectrumは、S3にあるデータをRedshiftへ取り込むのではなく、S3上のデータを外部テーブルとして参照できるようにした機能です。

S3上のデータ（外部テーブル）には複数のRedshiftクラスタからアクセスできたり、Redshift内のデータとS3上のデータに対してクエリを実行することもできます。また、利用頻度の低いデータをS3上に保持しておくことでRedshiftのディスクスペースを節約できるという利点もあります。

## Amazon Redshift ML
Amazon Redshift MLは、Redshiftデータウェアハウス内で機械学習モデルを作成、訓練、デプロイし、SQLを使用して大規模データセットに対して予測分析を行うサービスです。  
従来、データベース内のデータを用いた機械学習には、Amazon SageMakerのような機械学習サービスやPythonなどのプログラミング言語の知識が必要でしたが、Redshift MLの登場により、SQLに熟練しているデータベース開発者でも、機械学習プロセスを構築することができます。  
また、Redshift内でSQLのみの使用で機械学習が完結するため、作業の効率化も図れます。
