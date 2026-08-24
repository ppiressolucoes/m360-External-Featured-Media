# M360 External Featured Media — transição PEL v0.1.6

## Escopo

Este bundle instala a baseline já homologada no Mengão 360 no **staging** do Portal Energia Limpa. Não inclui credenciais, assets, posts, attachments ou configuração de outro portal.

## Instalação

1. Verifique o SHA-256 do ZIP do plugin contra `CHECKSUMS.txt`.
2. No WordPress do PEL, instale apenas `plugin/m360-external-featured-media-wordpress-v0.1.6.zip`.
3. Ative o plugin e confirme que há uma única entrada `M360 External Featured Media (Pilot)` na lista de plugins.
4. Crie no n8n uma Application Password exclusiva do PEL com `upload_files` e `edit_posts`.
5. Configure no n8n somente as credenciais Cloudinary do PEL.

## Preflight obrigatório

- WordPress `6.0+` e PHP `8.0+`;
- nenhuma rota existente em conflito com `m360/v1/external-featured-media`;
- registro idempotente por SHA-256;
- nenhum binário ou thumbnail criado em `uploads`;
- URL Cloudinary, imagem, `alt` e legenda corretos no frontend;
- na tradução EN-US, mesmo `attachment_id` e textos editoriais independentes.

## Rollback

Desative o workflow n8n e o plugin somente para novas publicações. Não exclua attachments virtuais, posts ou assets Cloudinary durante a observação; preserve as evidências para diagnóstico.
