-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exportar_titulo_pagar_v (ds_conteudo, dt_emissao) AS select	b.nr_cpf || ';' ||			-- 1 Pessoa Física
	a.nr_documento || ';' ||		-- 2 Número da nota
	';' ||					-- 3 Branco
	';' ||					-- 4 Branco
	to_char(dt_emissao,'dd') || ';' ||	-- 5 Somente dia de emissão
	b.nr_codigo_serv_prest || ';' ||	-- 6 Cód ativo municipal (Cadastro Completo de Pessoas)
	CASE WHEN(select 	count(*)		FROM	tributo_conta_pagar x,			tributo y		where 	x.cd_tributo		= y.cd_tributo		and	x.cd_pessoa_fisica 	= a.cd_pessoa_fisica		and	y.ie_tipo_tributo in ('ISS','ISSST'))=0 THEN 'TF'  ELSE 'TT' END  || ';' ||				-- 7 Situação
	a.vl_titulo || ';' ||			-- 8 Valor do título
	46132 || ';' ||				-- 9 Padrão 46132
	'R' || ';' ||				-- 10 Padrão 'R'
	';' ds_conteudo,			-- 11 Branco
	dt_emissao
from	pessoa_fisica b,
	titulo_pagar a
where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and	b.nr_codigo_serv_prest is not null
and	a.ie_situacao = 'L';

