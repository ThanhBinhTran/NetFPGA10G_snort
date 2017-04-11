#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0xcd71858e, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x1fedf0f4, __VMLINUX_SYMBOL_STR(__request_region) },
	{ 0x26520044, __VMLINUX_SYMBOL_STR(cdev_del) },
	{ 0xf1669456, __VMLINUX_SYMBOL_STR(kmalloc_caches) },
	{ 0xd2b09ce5, __VMLINUX_SYMBOL_STR(__kmalloc) },
	{ 0xb01e0219, __VMLINUX_SYMBOL_STR(cdev_init) },
	{ 0xf9a482f9, __VMLINUX_SYMBOL_STR(msleep) },
	{ 0x69a358a6, __VMLINUX_SYMBOL_STR(iomem_resource) },
	{ 0xc49deb04, __VMLINUX_SYMBOL_STR(skb_pad) },
	{ 0x43a53735, __VMLINUX_SYMBOL_STR(__alloc_workqueue_key) },
	{ 0x92a9c60c, __VMLINUX_SYMBOL_STR(time_to_tm) },
	{ 0x7fc215a, __VMLINUX_SYMBOL_STR(dma_set_mask) },
	{ 0x1bb017a1, __VMLINUX_SYMBOL_STR(pci_disable_device) },
	{ 0xfa78f0e3, __VMLINUX_SYMBOL_STR(device_destroy) },
	{ 0x31ba5de0, __VMLINUX_SYMBOL_STR(__dev_kfree_skb_any) },
	{ 0x7485e15e, __VMLINUX_SYMBOL_STR(unregister_chrdev_region) },
	{ 0xedaa7dc8, __VMLINUX_SYMBOL_STR(dma_free_attrs) },
	{ 0xb692a514, __VMLINUX_SYMBOL_STR(__netdev_alloc_skb) },
	{ 0x4f8b5ddb, __VMLINUX_SYMBOL_STR(_copy_to_user) },
	{ 0x4502841b, __VMLINUX_SYMBOL_STR(pci_set_master) },
	{ 0x1cb7f072, __VMLINUX_SYMBOL_STR(netif_tx_wake_queue) },
	{ 0x1916e38c, __VMLINUX_SYMBOL_STR(_raw_spin_unlock_irqrestore) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0xa6c92a68, __VMLINUX_SYMBOL_STR(class_unregister) },
	{ 0x4c9d28b0, __VMLINUX_SYMBOL_STR(phys_base) },
	{ 0x47c9c5de, __VMLINUX_SYMBOL_STR(free_netdev) },
	{ 0xd2eac02, __VMLINUX_SYMBOL_STR(register_netdev) },
	{ 0x9c8cf318, __VMLINUX_SYMBOL_STR(dma_alloc_attrs) },
	{ 0x5419e3dc, __VMLINUX_SYMBOL_STR(device_create) },
	{ 0x2072ee9b, __VMLINUX_SYMBOL_STR(request_threaded_irq) },
	{ 0xd6694e62, __VMLINUX_SYMBOL_STR(pci_clear_master) },
	{ 0x307aee44, __VMLINUX_SYMBOL_STR(cdev_add) },
	{ 0xe8b8978e, __VMLINUX_SYMBOL_STR(netif_receive_skb_sk) },
	{ 0x42c8de35, __VMLINUX_SYMBOL_STR(ioremap_nocache) },
	{ 0x8667032a, __VMLINUX_SYMBOL_STR(alloc_netdev_mqs) },
	{ 0x4404f8cc, __VMLINUX_SYMBOL_STR(eth_type_trans) },
	{ 0xbdfb6dbb, __VMLINUX_SYMBOL_STR(__fentry__) },
	{ 0x7c61340c, __VMLINUX_SYMBOL_STR(__release_region) },
	{ 0xa8e23b36, __VMLINUX_SYMBOL_STR(pci_enable_msi_range) },
	{ 0xdbbab0e0, __VMLINUX_SYMBOL_STR(pci_unregister_driver) },
	{ 0xbeb2eef2, __VMLINUX_SYMBOL_STR(ether_setup) },
	{ 0xab7d6a08, __VMLINUX_SYMBOL_STR(kmem_cache_alloc_trace) },
	{ 0x680ec266, __VMLINUX_SYMBOL_STR(_raw_spin_lock_irqsave) },
	{ 0x37a0cba, __VMLINUX_SYMBOL_STR(kfree) },
	{ 0x72a7bfa, __VMLINUX_SYMBOL_STR(pci_disable_msi) },
	{ 0xedc03953, __VMLINUX_SYMBOL_STR(iounmap) },
	{ 0x48d18b4a, __VMLINUX_SYMBOL_STR(__pci_register_driver) },
	{ 0x138cda43, __VMLINUX_SYMBOL_STR(class_destroy) },
	{ 0x973c6ccb, __VMLINUX_SYMBOL_STR(unregister_netdev) },
	{ 0x2e0d2f7f, __VMLINUX_SYMBOL_STR(queue_work_on) },
	{ 0x539c6cb1, __VMLINUX_SYMBOL_STR(skb_put) },
	{ 0x790c0a26, __VMLINUX_SYMBOL_STR(pci_enable_device) },
	{ 0x4f6b400b, __VMLINUX_SYMBOL_STR(_copy_from_user) },
	{ 0x962b781d, __VMLINUX_SYMBOL_STR(__class_create) },
	{ 0x638ba5fc, __VMLINUX_SYMBOL_STR(dma_ops) },
	{ 0x29537c9e, __VMLINUX_SYMBOL_STR(alloc_chrdev_region) },
	{ 0xf20dabd8, __VMLINUX_SYMBOL_STR(free_irq) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

MODULE_ALIAS("pci:v000010EEd00004244sv*sd*bc*sc*i*");

MODULE_INFO(srcversion, "DE8285E61A906B364FA5C35");
