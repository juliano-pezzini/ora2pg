-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tasy_padrao_imagem_v (nr_seq_legenda, nr_seq_apresent, cd_estabelecimento, cd_perfil, ie_imagem, ds_legenda, ie_utilizado) AS select	a.nr_seq_legenda,
	a.nr_seq_apresent,
	b.cd_estabelecimento,
	b.cd_perfil,
	coalesce(b.ie_imagem,a.ie_imagem) ie_imagem,
	coalesce(b.ds_legenda, a.ds_legenda) ds_legenda,
	coalesce(b.ie_utilizado,'S') ie_utilizado
FROM tasy_padrao_imagem a
LEFT OUTER JOIN tasy_padrao_imagem_perfil b ON (a.nr_sequencia = b.nr_seq_padrao);

