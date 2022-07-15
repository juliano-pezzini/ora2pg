-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_copia_preco (cd_estabelecimento_p bigint, cd_tabela_servico_p bigint, cd_procedimento_p bigint, dt_inicio_vigencia_p timestamp) AS $body$
BEGIN

delete	from preco_servico
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_tabela_servico = cd_tabela_servico_p
and	cd_procedimento = cd_procedimento_p
and	dt_inicio_vigencia = dt_inicio_vigencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_copia_preco (cd_estabelecimento_p bigint, cd_tabela_servico_p bigint, cd_procedimento_p bigint, dt_inicio_vigencia_p timestamp) FROM PUBLIC;

