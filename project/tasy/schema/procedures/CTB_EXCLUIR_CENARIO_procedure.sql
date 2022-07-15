-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_excluir_cenario (nr_seq_cenario_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_cenario_w			varchar(80);


BEGIN

select	max(ds_cenario)
into STRICT	ds_cenario_w
from	ctb_orc_cenario
where	nr_sequencia 	= nr_seq_cenario_p;

insert into ctb_log(
	cd_log,
	ds_log,
	nm_usuario,
	dt_atualizacao)
values (	433,
	substr(wheb_mensagem_pck.get_texto(298773,null) || ' ' || nr_seq_cenario_p || ' ' || ds_cenario_w,1,2000),
	--'Exclusao do cenario: ' || nr_seq_cenario_p || ' ' || ds_cenario_w,
	nm_usuario_p,
	clock_timestamp());

delete	from ctb_cen_metrica
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_cen_ticket_medio
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_orc_cen_valor
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_regra_metrica
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_regra_ticket_medio
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_orc_cen_regra
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_cen_historico
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_orc_cen_arquivo
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_metrica_acomp
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from w_ctb_acomp_valor
where	nr_seq_cenario	= nr_seq_cenario_p;

delete	from ctb_orc_cenario
where	nr_sequencia	= nr_seq_cenario_p;

delete	from ctb_planej_orc_material
where	nr_seq_planej	= nr_seq_cenario_p;

delete	from ctb_planej_orc_valor
where	nr_seq_planej	= nr_seq_cenario_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_excluir_cenario (nr_seq_cenario_p bigint, nm_usuario_p text) FROM PUBLIC;

