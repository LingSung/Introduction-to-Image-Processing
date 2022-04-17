Image Processing Lab2 Readme
===
### proj03_01
- 已將.m檔與圖片都放到資料夾內，因此直接打開project03_01.m，無須更改任何的code，就可以直接執行了
- 執行結果會有一張figure(由原圖、log transformation與6張不同gamma值所產生的power-law transformation的圖所構成)

### proj03_02
- 已將.m檔與圖片都放到資料夾內，因此直接打開project03_02.m，無須更改任何的code，就可以直接執行了
- 執行結果會有一張figure(總共兩排。第一排由原圖、原圖的histogram、histogram equalization transformation function三張圖所組成。第二排為enhance後的結果圖和它的histogram組成)

### proj03_03
- 已將.m檔與圖片都放到資料夾內，因此直接打開project03_03.m，無須更改任何的code，就可以直接執行了
- 執行結果會有1張figure(原圖與high-boost filter的結果圖所構成)
- Proj03_03的部分是寫成一個function名為spatial_filter，直接放在project03_03.m檔中。function的input為image與mask，如果助教想要修改mask來測試convolution的正確性，可以修改主程式中變數mask的值即可，目前預設為全部都是1的3x3 array。
    ```matlab
        mask = [1,1,1;1,1,1;1,1,1];
    ```