# Copyright (C) 2020 The Proton AOSP Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit vendor submodules
$(call inherit-product, vendor/proton/apps/apps.mk)
$(call inherit-product, vendor/proton/bootanimation/bootanimation.mk)
$(call inherit-product, vendor/proton/fonts/fonts.mk)
$(call inherit-product, vendor/proton/overlay/overlay.mk)
$(call inherit-product, vendor/proton/telephony/telephony.mk)
$(call inherit-product, vendor/proton/audio/audio.mk)
$(call inherit-product-if-exists, vendor/proton/signing/dev.mk)
$(call inherit-product, vendor/proton/build/qcom_boards.mk)

# Flatten APEXs for performance
# TODO: fix Pixel 6 camera HAL flattening and re-enable this
ifeq ($(filter raven oriole,$(TARGET_DEVICE)),)
OVERRIDE_TARGET_FLATTEN_APEX := true
# This needs to be specified explicitly to override ro.apex.updatable=true from
# prebuilt vendors, as init reads /product/build.prop after /vendor/build.prop
PRODUCT_PRODUCT_PROPERTIES += ro.apex.updatable=false
endif
# Disable compressed APEX if not flattened
OVERRIDE_PRODUCT_COMPRESSED_APEX := false

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Enable one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Enable gestural navigation overlay to match default navigation mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

# Charger mode images
PRODUCT_PACKAGES += \
    charger_res_images

# Charger Images
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/proton/charger,$(TARGET_COPY_OUT_PRODUCT)/etc/res)

# AOSP userdebug/eng CLI tools
PRODUCT_PACKAGES += \
    arping \
    dmuserd \
    gdbserver \
    idlcli \
    iotop \
    iperf3 \
    iw \
    procrank \
    profcollectd \
    profcollectctl \
    showmap \
    sqlite3 \
    ss \
    strace \
    tracepath \
    tracepath6 \
    traceroute6 \
    procmem \
    curl \

# LineageOS CLI tools
PRODUCT_PACKAGES += \
    7z \
    bash \
    htop \
    nano \
    pigz \
    vim \
    zip \
    rsync \

# AOSP OpenSSH
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh \

# Blur
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.launcher.blur.appLaunch=false

# Gapps
ifeq ($(WITH_GMS),true)

$(call inherit-product, vendor/gms/products/gms.mk)

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.rotation_locked=true \
    setupwizard.theme=glif_v3_light \

# Google Assistant
PRODUCT_PRODUCT_PROPERTIES += \
    ro.opa.eligible_device=true \

# Client ID
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google \

endif

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l?=4 \
    ro.com.google.ime.kb_pad_port_r?=4 \
    ro.com.google.ime.kb_pad_land_l?=64 \
    ro.com.google.ime.kb_pad_land_r?=64 \

# Navbar
PRODUCT_PACKAGES += \
    NavigationBarNoHintOverlay

# PixelPropsUtils
PRODUCT_COPY_FILES += \
    vendor/proton/prebuilt/common/etc/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml

# QTI Bluetooth
ifneq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += packages/apps/Bluetooth
endif #TARGET_USE_QTI_BT_STACK

# Extra packages
PRODUCT_PACKAGES += \
    libjni_latinimegoogle
