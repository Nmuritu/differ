#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define  RECEIPT  1506640320
#define  LAYERSPRICE  50
#define  GROWERSPRICE 60
#define  MAIZEJAMPRICE 45



int generateReceiptNo(){
    int receiptNumber =+ 1506640320;
    return receiptNumber;
}

void getHeader(){
    printf("\n\t\t\t\t\t\t\t*********************");
    printf("\n\t\t\t\t\t\t\t Paid Sale Receipt");
    printf("\n\t\t\t\t\t\t\t ALGO FEEDS KENYA");
    printf("\n\t\t\t\t\t\t\t Contact +254232191");
    printf("\n\n\t\t\t\t\t\t\t*********************");
    int receiptNumber = generateReceiptNo();
    printf("\n\n\nReciept No: %d\n",receiptNumber);
   

}

int getService(int choice){
    printf("\n\tPlease select your preferred operation");
    printf("\n\t1.Start service ");
    printf("\n\t2.Print invoice");
    printf("\n\t3.Delete invoice");
    printf("\n\t4.exit");
    printf("\n");
    printf("\nEnter your choice: ");
    scanf("%d",&choice);
    return choice;
}

int modeOfEntry(int mode_of_entry){
    printf("\nPlease choose mode of entry");
    printf("\n1.Walk in");
    printf("\n2.Drive in");
    printf("\nEnter your choice: ");
    scanf("%d",&mode_of_entry);
    return mode_of_entry;

}

int getMenu(){
    int comodities;
    printf("\nPlease select puchased comodities");
    printf("\n1.Layers");
    printf("\n2.Growers");
    printf("\n3.Maize Jam");
    printf("\n4.More than one comodity");
    printf("\nPlease select the viable option: ");
    scanf("%d",&comodities);
    return comodities;

}

int getQuantity(){
    int quantity;
    /*printf("\nPlease select quantity of comodity");
    printf("\n1.1-60 kg(s)");
    printf("\n2.No of bags");
    printf("\n3.More than 60 kgs but less than a set number of whole bags");*/
    printf("\nEnter the quantity: ");
    scanf("%d",&quantity);
    return quantity;

}

int priceCalculator(int quantity,int comodities){
    switch(comodities)
    {
        case 1:
            int totalPriceLayer = LAYERSPRICE * quantity;
            //printf("Total price : %d\n",totalPriceLayer);
            return totalPriceLayer;
            break;
        case 2:
            int totalPriceGrower = GROWERSPRICE * quantity;
            //printf("Total price : %d\n",totalPriceGrower);
            return totalPriceGrower;
            break;
        case 3:
            int totalPriceMaizeJam = MAIZEJAMPRICE * quantity;
            //printf("Total price : %d\n",totalPriceMaizeJam);
            return totalPriceMaizeJam;
            break;
        default:
            printf ("Check the item and retry\n");
    }
    return 0;
}

void startService(int choice){
    printf("\n");

}
                        


void getFooter(char serviceattendant[20]){
    printf("\n\n");
    printf("\nServed by: %s", serviceattendant);
    //printf("\nON: %s",tm);
    //printf("\nPrinted on: %s",tm);
    printf("\n\t\t\t\t\t\tOriginal");
    printf("\n\t\t\t\tThank you for shoping with us");
    printf("\n\t\t\t\t\tPowered by iPOS\n");
}

void generateReceipt(int comodities, int quantity, int totalPrice){
    system("clear");
    int price;
    getHeader();
    switch(comodities)
    {
        case 1:
            printf("\tLayers\t\t");
            price = LAYERSPRICE;
        case 2:
            printf("\tGrowers\t\t");
            price = GROWERSPRICE;
        case 3:
            printf("\tMaizeJam\t\t");
            price = MAIZEJAMPRICE;
    }
    printf("%d kgs",quantity);
    printf("\n\tksh. %d",price);
    printf("\t\tTotals: %d\n",totalPrice);
}



int main(){
    int comodities,quantity,totalPrice;
    char serviceattendant[20]; 
    comodities = getMenu();
    quantity = getQuantity();
    totalPrice = priceCalculator(quantity,comodities);  
    generateReceipt(comodities,quantity,totalPrice);
    return 0;
}