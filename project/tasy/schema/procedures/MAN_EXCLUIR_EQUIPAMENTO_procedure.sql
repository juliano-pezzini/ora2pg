-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_excluir_equipamento ( nr_seq_equipamento_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_equipamento_w	varchar(80);
ds_ordens_w	varchar(2000);


BEGIN

select	substr(obter_select_concatenado_bv('select nr_sequencia from man_ordem_servico
				where nr_seq_equipamento = :nr','nr= ' || nr_seq_equipamento_p,','),1,2000)
into STRICT	ds_ordens_w
;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_excluir_equipamento ( nr_seq_equipamento_p bigint, nm_usuario_p text) FROM PUBLIC;

