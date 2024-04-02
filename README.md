
# CD 2023 Project - Distributed Music Editor

Bernardo Pinto - 105926

João Santos - 110555

## Introduction

The system aims not only to remove vocals from songs but also allows users to eliminate individual instruments, empowering musicians to replace original performances with their own, as commonly seen in karaoke. The objective is to create a web portal that enables musicians to upload their files, analyze instruments, select specific ones, and receive a new file containing only the chosen instruments. Leveraging parallel processing, our system distributes tasks among multiple independent workers, ensuring quick instrument identification and efficient file creation for an enhanced user experience.

[Here](GuiaoProjeto.pdf) is a guide to getting started with the job.

[Here](Relatorio.pdf) is a brief final report of the work carried out.


Here we have a sample code that loads one mp3 file and splits it 
into 4 tracks: vocals, drums, bass and other.

The codes uses one library named [demucs](https://github.com/facebookresearch/demucs),
this library uses a deep learning model to separate the tracks.
This library requires [ffmpeg](https://ffmpeg.org/) to work.
It should be present in most Linux distributions.

## Example

This serves as an illustration of how to execute the program.

To conduct this test, you'll utilize curl requests, although alternatively, you can opt for the interface available at [http://localhost:5000](http://localhost:5000).
#### 1) Run the following script to start the server and celery workers
```bash
./run.sh # 2 workers are used by default
```

or

```bash
./run.sh {number_of_workers} # specify the number of workers
```
Then, you'll have 2 or more terminal windows open (one for the server and one for each worker).


#### 2) Now, you can run the following command to upload a [test music file](test.mp3) to the server
```bash
curl -F music_file=@'test.mp3' http://localhost:5000/music
```
output:
```json
{
"artist":"Unknown Artist",
"id":1,
"title":"bensound-wildblood",
"tracks":[{"name":"drums","track_id":"11"},{"name":"bass","track_id":"12"},{"name":"vocals","track_id":"13"},{"name":"other","track_id":"14"}]
}
```

#### 3) Once the music is uploaded, you can select the tracks you wish to download:
```bash
curl -X POST -F "id=1" -F "vocals=vocals" -F "drums=drums" http://localhost:5000/music/1
# id is the id of the music file, vocals, drums, bass and other are the tracks you want to download
```
The workload will then be distributed among the workers, and you can monitor the progress percentage in each worker's terminal.

#### 4) Upon completion of the task, you can access the downloads for each selected track individually, as well as the "final" version that combines the tracks you selected (e.g., vocals and drums) via the following link:

http://localhost:5000/music/1?id=1

#### 5) Results for testing by selecting vocals and drums:

- [original music](test.mp3)
- [vocals](static/tracks/1_vocals.mp3)
- [drums](static/tracks/1_drums.mp3)
- [final (vocals + drums)](static/tracks/1_final.mp3)






## Dependencies

For Ubuntu (and other debian based linux), run the following commands:

```bash
sudo apt install ffmpeg
```

## Setup

Run the following commands to setup the environement:
```bash
mkdir tracks

python3 -m venv venv
source venv/bin/activate

pip install pip --upgrade
pip install -r requirements_torch.txt
pip install -r requirements_demucs.txt
```

It is important to install the requirements following the previous instructions.
By default, PyTorch will install the CUDA version of the library (over 4G simple from the virtual environment).
As such, the current instructions force the installation of the CPU version of PyTorch and then installs Demucs.


## Usage

The sample main code only requires two parameters:
- **i** the mp3 file used for input
- **o** the folder for the output

Two audio tracks are given (download them from [here](https://filesender.fccn.pt/?s=download&token=cd4fcd29-b3f1-4a4d-9da3-50aae00e702d)):
- **test.mp3** a short sample (0:34) that allows for a quick validation
- **mudic.mp3** a long (59:04) sequence of royalty free rock musics that are the target of the work

Both audio files are royalty free.

To run test the sample code simple run:
```bash
python main.py -i test.mp3
```


## Authors

* **Mário Antunes** - [mariolpantunes](https://github.com/mariolpantunes)
* **Diogo Gomes** - [dgomes](https://github.com/dgomes)
* **Nuno Lau** - [nunolau](https://github.com/nunolau)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
