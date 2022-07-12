-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pessoa_juridica_fisica_rfc_v (cd_codigo, nm_pessoa, cd_rfc, ie_tipo_pessoa) AS select	b.cd_pessoa_fisica cd_codigo,
	b.nm_pessoa_fisica nm_pessoa,
	b.cd_rfc cd_rfc,
	'F' ie_tipo_pessoa
FROM	pessoa_fisica b

union

select	b.cd_cgc cd_codigo,
	b.ds_razao_social nm_pessoa,
	b.cd_rfc cd_rfc,
	'J' ie_tipo_pessoa
from	pessoa_juridica b
order by 2;
