-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW email_search_tool_v (ds_grupo, nm_usuario, ds_usuario, nm_usuario_grupo, ds_email, ie_todos_usuarios, nm_usuario_exclusivo, nr_seq_grupo) AS select	b.ds_grupo,
		c.nm_usuario,
		c.ds_usuario,
		a.nm_usuario_grupo,
		c.ds_email,
		'N' ie_todos_usuarios,
		b.nm_usuario_exclusivo,
		b.nr_sequencia nr_seq_grupo
FROM	usuario c,
		grupo_usuario b,
		usuario_grupo a
where	a.nr_seq_grupo = b.nr_sequencia
and		a.nm_usuario_grupo = c.nm_usuario
and		c.ds_email is not null

union

select	'Usuário' ds_grupo,
		c.nm_usuario,
		c.ds_usuario,
		c.nm_usuario nm_usuario_grupo,
		c.ds_email,
		'S' ie_todos_usuarios,
		null nm_usuario_exclusivo,
		null nr_seq_grupo
from	usuario c
where	c.ie_situacao = 'A'
and		c.ds_email is not null;
