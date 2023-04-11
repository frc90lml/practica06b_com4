if(exist('OCTAVE_VERSION','builtin')~=0)

pkg load signal;
end
%MENU
opcion = 0;
while opcion ~=5
  disp('Seleccione una opcion')
  disp('1.Grabar')
  disp('2.Reproducir')
  disp('3.Graficar')
  disp('4.Graficar densidad')
  disp('5 opción nueva')
  disp('6.Señal monoaural')
  disp('7. 06b')
  disp('8. Reproducir audio 06b')
  disp('9. Salir')
  opcion = input('Ingrese su elección:');
switch opcion
  case 1
    try
      duracion = input('Ingrese la duración de la grabación en segundos:');
      disp('Comenzando la grabación');
      recObj = audiorecorder;
      recordblocking(recObj, duracion);
      disp('Grabacion finalizada');
      data= getaudiodata(recObj);
      audiowrite('audio.wav', data, recObj.SampleRate);
      disp('Archivo de audio grabado correctamente');
    catch
      disp('Error al grabar audio');
    end_try_catch

  case 2
    try
      [data, fs] = audioread('audio.wav');
      sound(data, fs);
    catch
      disp('Error al reproducir el audio');
    end_try_catch

  case 3
    try
      [data, fs]=audioread('audio.wav');
      tiempo = linspace(0, length(data)/fs, length(data));
      plot(tiempo, data);
      xlabel('Tiempo(s)');
      ylabel('Amplitud');
      title('Audio');
    catch
      disp('Error al graficar el audio');
    end_try_catch

  case 4
    try
      disp('Graficando espectro de frecuencia');
      [audio, Fs] = audioread('audio.wav');
      N = length(audio);
      f = linspace(0, Fs/2, N/2+1);
      ventana = hann(N);
      Sxx= pwelch(audio, ventana, 0, N, Fs);
      plot(f, 10*log10(Sxx(1:N/2+1)));
      xlabel('Frecuencia (Hz)');
      ylabel('Densidad espectral de potencia(dB/Hz)');
      title('Espectro de freuencia de la señal grabada');
    catch
      disp('Error al graficar audio');
    end_try_catch

    case 5
    try
  [input_signal, fs] = audioread('audio.wav')
  %rfi
  fc = 1000;
  bw = 500;
   Wn = [fc-bw/2, fc+bw/2]/(fs/2);

   [b,a] = butter(2,Wn);
    fn = 1200;
    Wn_notch = fn/(fs/2);
    [b_notch, a_notch]= pei_tseng_notch(Wn_notch, 0.1);

    b_total=conv(b,b_notch);
    a_total=conv(a,a_notch);
     filtered_signal_RFI=filter(b_total,a_total,input_signal);

     fc=1000;
     gain=20;
     Wn=fc/(fs/2);

     [b,a]=cheby1(3,gain,Wn,'high');

     filtered_signal_RII=filter(b,a,filtered_signal_RFI);

     t=0:1/fs:(length(input_signal)-1)/fs;
     figure();
     plot(t, input_signal);
     xlabel('Tiempo (s)');
     ylabel('Amplitud');
     title('Señal original');

     t=0:1/fs:(length(filtered_signal_RFI)-1)/fs;
     figure();
     plot(t, filtered_signal_RFI);
     xlabel('Tiempo(s)');
     ylabel('Amplitud');
     title('señal filtrada con filtro RFI');

     t=0:1/fs:(length(filtered_signal_RII)-1)/fs;
     figure();
     plot(t,filtered_signal_RII);
     xlabel('Tiempo(s)');
     ylabel('Amplitud');
     title('Señal filtrada con filtro RII');

    catch

    end_try_catch

    case 6
    try
     [x, fs] = audioread('audio.wav');
     x= mean(x, 2);
     z=tf(x,1);
     [b, a] = tfdata(z, 'vector');
     y= filter(b,a,x);

     t=0:1/fs:(length(x)-1)/fs;
     subplot(2, 1, 1);
     plot(t,x);
     xlabel('tiempo (s)');
     ylabel('Amplitud');
     title('Señal Original');

     subplot(2, 1, 2);
     plot(t, y);
     xlabel('tiempo (s)');
     ylabel('Amplitud');
     title('Señal con transformaa Z aplicada');

     audiowrite("archivo_audio_con_Z.wav", y, fs);
    catch
  end_try_catch

case 7
  try
    pkg load signal
    #leer archivo
    [y, fs] = audioread('audio.wav');

    #Realizar DCT
    dct_y = dct(y);

    #Establecer el umbral para compresion
    umbral =0,1;
    #comprimir DCT
    dct_y_comprimido= dct_y.*(abs(dct_y)>umbral);
    #realiza la inversa de la DCT para obtener archivo comprimido
    y_comprimido=idct(dct_y_comprimido);

    #graficar archivo inicial y final
    t=(0:length(y)-1)/fs;
    t_comp=(0:length(y_comprimido)-1)/fs;
    subplot(2,1,1);
    plot(t,y);
    title('Archivo de audio inicial');
    xlabel('Tiempo (s)');
    ylabel('Amplitud');

    subplot(2,1,2);
    plot(t_comp, y_comprimido);
    title('Archivo de audio comprimido');
    xlabel('Tiempo (s)');
    ylabel('Amplitud');

    audiowrite("archivo_audio_comprimido.wav", y, fs);
  catch
  end_try_catch

 case 8
    try
      [data, fs] = audioread('archivo_audio_comprimido.wav');
      sound(data, fs);
    catch
      disp('Error al reproducir el audio');
    end_try_catch

  case 9
    disp('Saliendo del programa');
    break
  otherwise
    disp('Opción inválida');
end
end
