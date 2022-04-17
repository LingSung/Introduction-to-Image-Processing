### Proj02_02
- 已將.m檔與圖片都放到資料夾內，因此直接打開project02_02.m，無須更改任何的code，就可以直接執行了
- 執行結果會有兩張figure(一個為原圖，一個為quantization後8種不同level的圖)

### Proj02_03
- 已將.m檔與圖片都放到資料夾內，因此直接打開project02_03.m，無須更改任何的code，就可以直接執行了
- 執行結果會有一張figure(原圖與nearest neighbor的結果圖所構成)
- Report中 **nearest vs bilinear對照圖**，只需把project02_03.m中的這段程式碼的註解拿掉，即可執行。執行結果除了作業要求的比較圖，還會有nearest vs bilinear對照圖，總共兩個figure。
    ``` matlab
    %{
        figure(2);
        bilinear_img = Bilinear(output);
        bilinear_img = uint8(bilinear_img);
        subplot(1,2,1),imshow(bilinear_img),title('zoom/shrink using bilinear interpolation');
        subplot(1,2,2),imshow(img_resized),title('zoom/shrink using pixel replication');
    %}
    ```

### Proj02_04
- 已將.m檔與圖片都放到資料夾內，因此直接打開project02_04.m，無須更改任何的code，就可以直接執行了
- 執行結果會有1張figure(原圖與bilinear的結果圖所構成)