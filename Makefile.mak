CC=arm-none-eabi-gcc
MACH=cortex-m4
CFLAGS= -c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -std=gnu17 -Wall -o0
LDFLAGS= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T stm32_ls.ld -Wl,-Map=final.map
LDFLAGS_SH= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=rdimon.specs -T stm32_ls.ld -Wl,-Map=final.map
source= main.c led.c stm32_startup.c syscalls.c

all: clean main.o led.o stm32_startup.o syscalls.o final.elf

semi:main.o led.o stm32_startup.o syscalls.o final_sh.elf

gitall:git add status push

main.o:main.c
	$(CC) $(CFLAGS) $^ -o $@

led.o:led.c
	$(CC) $(CFLAGS) $^ -o $@

stm32_startup.o:stm32_startup.c
	$(CC) $(CFLAGS) $^ -o $@

syscalls.o:syscalls.c
	$(CC) $(CFLAGS) $^ -o $@
	
final.elf:main.o led.o stm32_startup.o syscalls.o
	$(CC) $(LDFLAGS) $^ -o $@
	
final_sh.elf:main.o led.o stm32_startup.o
	$(CC) $(LDFLAGS_SH) $^ -o $@

clean:
	rm -rf *.o *.elf
	
load:
	openocd -f board/stm32f4discovery.cfg

analysis:
	cppcheck --enable=all --inconclusive $(source)

git:
	git init

add:
	git add .
	git commit -m="$m"
	
status:
	git status
	
clone:
	git clone "$c"
	
push:
	git push

pull:
	git pull
