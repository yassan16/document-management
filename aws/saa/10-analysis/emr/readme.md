# Amazon EMR
Amazon EMRは、ビッグデータの処理や分析を行うサービスです。  
ビッグデータを処理する既存のフレームワークであるHadoop（ハドゥープ）やSpark（スパーク）を用いています。  
さらに、ビッグデータを分析し経営に役立てることを「BI：Business Intelligence」といい、代表的なBIツールにはMicrosoft ExcelやMicroStrategyなどがあります。Amazon EMRはこれらのツールにも対応しています。

* Glueよりも大規模なデータを扱う場合に適しています。　　
* ETLに利用できますが、クラスター構成のEC2インスタンスを管理する必要があり

## HDFSとEMRFS（EMR File System）
EMRでは、ファイルシステムとしてHDFSとEMRFSを利用できます。

### HDFS（Hadoop Distributed File System）
分散処理ソフトウェア「Hadoop」のファイルシステムです。EMRではマスターノードとコアノードで利用します。
EMRクラスターが終了すると、HDFS上のデータは失われます。

### EMRFS（EMR File System）
Amazon S3をEMRクラスターからファイルシステムとして利用できるようにした機能です。
データを永続的に保持でき、EMRクラスターが終了してもデータは失われません。また、S3が持つ機能（データの暗号化やデータ読み込み時の強い一貫性のサポートなど）も備わっています。