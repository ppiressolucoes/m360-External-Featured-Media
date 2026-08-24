# Baseline de produção v0.1.6

Evidência de produção: Mengão 360, 24/08/2026.

Esta baseline registra attachments virtuais Cloudinary, mantém os binários fora de `uploads`, reutiliza a mesma mídia entre PT-BR e EN-US e resolve `alt`/legenda no contexto do post exibido.

O pacote WordPress deve conter a pasta `m360-external-featured-media/` e o arquivo principal `m360-external-featured-media.php`. Não embuta credenciais, assets, conteúdo ou configuração de um portal no repositório ou no pacote.

Para o Portal Energia Limpa, instale primeiro em staging e valide: endpoints autenticados, idempotência por SHA-256, nenhuma escrita de imagem em `uploads`, renderização no frontend e reuso do mesmo `attachment_id` na tradução.
