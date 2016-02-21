#include "emu.h"

#include "texture.h"

bgfx_texture::bgfx_texture(std::string name, bgfx::TextureFormat::Enum format, uint32_t width, uint32_t height, void* data, uint32_t flags)
	: m_name(name)
	, m_format(format)
	, m_width(width)
	, m_height(height)
{
	bgfx::TextureInfo info;
	bgfx::calcTextureSize(info, width, height, 1, false, 1, format);
	if (data != nullptr)
	{
		m_handle = bgfx::createTexture2D(width, height, 1, format, flags, bgfx::copy(data, info.storageSize));
	}
	else
	{
		m_handle = bgfx::createTexture2D(width, height, 1, format, flags);

		const bgfx::Memory* memory = bgfx::alloc(info.storageSize);
		memset(memory->data, 0, info.storageSize);
		bgfx::updateTexture2D(m_handle, 0, 0, 0, width, height, memory, info.storageSize / height);
	}
}

bgfx_texture::~bgfx_texture()
{
	bgfx::destroyTexture(m_handle);
}
