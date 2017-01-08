/*
 * KLD Bexkat
 */

#include <sys/types.h>
#include <sys/module.h>
#include <sys/systm.h>  /* uprintf */
#include <sys/errno.h>
#include <sys/param.h>  /* defines used in kernel.h */
#include <sys/kernel.h> /* types used in module initialization */
#include <sys/conf.h>
#include <sys/uio.h>
#include <sys/malloc.h>
#include <sys/bus.h>

#include <machine/bus.h>
#include <sys/rman.h>
#include <machine/resource.h>

#include <dev/pci/pcivar.h>
#include <dev/pci/pcireg.h>

#define BUFFERSIZE 255

static d_open_t bexkat_open;
static d_close_t bexkat_close;
static d_read_t bexkat_read;
static d_write_t bexkat_write;

struct s_bexkat {
  char msg[BUFFERSIZE + 1];
  int len;
};

struct bexkat_softc {
  device_t bexkat_dev;
  struct cdev *bexkat_cdev;
  int bar0id;
  struct resource *bar0res;
  bus_space_tag_t bar0_bt;
  bus_space_handle_t bar0_bh;
};

static struct cdevsw bexkat_cdevsw = {
  .d_version = D_VERSION,
  .d_open = bexkat_open,
  .d_close = bexkat_close,
  .d_read = bexkat_read,
  .d_write = bexkat_write,
  .d_name = "bexkat",
};

static int
bexkat_open(struct cdev *dev, int oflags __unused, int devtype __unused,
  struct thread *td __unused)
{
  struct bexkat_softc *sc = dev->si_drv1;
  device_printf(sc->bexkat_dev, "Opened device successfully.\n");
  return (0);
}

static int
bexkat_close(struct cdev *dev, int fflag __unused, int devtype __unused,
  struct thread *td __unused)
{
  struct bexkat_softc *sc = dev->si_drv1;
  device_printf(sc->bexkat_dev, "Closing device.\n");
  return (0);
}

static int
bexkat_read(struct cdev *dev, struct uio *uio, int ioflag __unused)
{
  unsigned int res;
  int error;
  struct bexkat_softc *sc = dev->si_drv1;
  device_printf(sc->bexkat_dev, "Asked to read %ld bytes\n", uio->uio_resid);
  res = bus_space_read_4(sc->bar0_bt, sc->bar0_bh, 0x20);
  device_printf(sc->bexkat_dev, "Read %08x\n", res);
  if ((error = uiomove("h", 1, uio)) != 0)
    device_printf(sc->bexkat_dev, "read failed\n");
 
  return (error);
}

static int
bexkat_write(struct cdev *dev, struct uio *uio, int ioflag __unused)
{
  struct bexkat_softc *sc = dev->si_drv1;
  int error;
  char x;
  error = uiomove(&x, 1, uio);
  bus_space_write_1(sc->bar0_bt, sc->bar0_bh, 0x80000, x);
  device_printf(sc->bexkat_dev, "Asked to write %ld bytes\n", uio->uio_resid);
  if (error != 0)
    device_printf(sc->bexkat_dev, "write failure\n");
  return (error);
}

static int
bexkat_probe(device_t dev)
{
  device_printf(dev, "Bexkat probe\nVendor ID : 0x%x\nDevice ID : 0x%x\n",
    pci_get_vendor(dev), pci_get_device(dev));
  if (pci_get_vendor(dev) == 0x1172 && pci_get_device(dev) == 0x0004) {
    printf("Found Bexkat device\n");
    device_set_desc(dev, "Bexkat");
    return (BUS_PROBE_DEFAULT);
  }
  return (ENXIO);
}

static int
bexkat_attach(device_t dev)
{
  struct bexkat_softc *sc;

  printf("Bexkat attach for : deviceID : 0x%x\n", pci_get_devid(dev));

  sc = device_get_softc(dev);
  sc->bexkat_dev = dev;

  sc->bar0id = PCIR_BAR(0);
  sc->bar0res = bus_alloc_resource_any(dev, SYS_RES_MEMORY, &sc->bar0id, RF_ACTIVE);
  if (sc->bar0res == NULL) {
    printf("Member alloc of PCI reg0 failed\n");
    return (ENXIO);
  }

  sc->bar0_bt = rman_get_bustag(sc->bar0res);
  sc->bar0_bh = rman_get_bushandle(sc->bar0res);
  bus_space_write_1(sc->bar0_bt, sc->bar0_bh, 0x80000, 0x00);

  sc->bexkat_cdev = make_dev(&bexkat_cdevsw, device_get_unit(dev),
    UID_ROOT, GID_WHEEL, 0666, "bexkat%u", device_get_unit(dev));
  sc->bexkat_cdev->si_drv1 = sc;
  return (0);
}

static int
bexkat_detach(device_t dev)
{
  struct bexkat_softc *sc;

  sc = device_get_softc(dev);
  destroy_dev(sc->bexkat_cdev);
  printf("Bexkat detach\n");
  return (0);
}

static int
bexkat_shutdown(device_t dev)
{
  printf("Bexkat shutdown\n");
  return (0);
}

static int
bexkat_suspend(device_t dev)
{
  printf("Bexkat suspend\n");
  return (0);
}

static int
bexkat_resume(device_t dev)
{
  printf("Bexkat resume\n");
  return (0);
}

static device_method_t bexkat_methods[] = {
  DEVMETHOD(device_probe, bexkat_probe),
  DEVMETHOD(device_attach, bexkat_attach),
  DEVMETHOD(device_detach, bexkat_detach),
  DEVMETHOD(device_shutdown, bexkat_shutdown),
  DEVMETHOD(device_suspend, bexkat_suspend),
  DEVMETHOD(device_resume, bexkat_resume),
  DEVMETHOD_END
};

static devclass_t bexkat_devclass;

DEFINE_CLASS_0(bexkat, bexkat_driver, bexkat_methods, sizeof(struct bexkat_softc));
DRIVER_MODULE(bexkat, pci, bexkat_driver, bexkat_devclass, 0, 0);
//DECLARE_MODULE(bexkat, bexkat_mod, SI_SUB_KLD, SI_ORDER_ANY);
