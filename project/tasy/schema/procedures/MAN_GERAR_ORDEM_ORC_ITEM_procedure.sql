-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_ordem_orc_item ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



NR_SEQ_APRES_w		man_ord_serv_orc_item.nr_seq_apres%type;
nr_seq_ordem_w		bigint;
qt_existe_w		bigint;
ds_atividade_w		Man_Ordem_Ativ_Prev.ds_atividade%type;
ds_observacao_w		Man_Ordem_Ativ_Prev.ds_observacao%type;
qt_min_prev_w		double precision;
vl_hora_unit_w		double precision;
vl_cobranca_w		double precision;
cd_unidade_medida_w	Unidade_Medida.cd_unidade_medida%type;

c01 CURSOR FOR
SELECT	ds_atividade,
	ds_observacao,
	dividir(coalesce(qt_min_prev,0),60),
	(dividir(round((coalesce(vl_cobranca,0))::numeric,1),coalesce(qt_min_prev,0)) * 60),
	coalesce(vl_cobranca,0)
from	Man_Ordem_Ativ_Prev
where	nr_seq_ordem_serv	= nr_seq_ordem_w
order	by dt_prevista;


BEGIN

delete	FROM man_ord_serv_orc_item
where	coalesce(cd_material::text, '') = ''
and	nr_seq_orc_ordem = nr_sequencia_p;

select	coalesce(max(nr_seq_apres), 0) + 1
into STRICT	nr_seq_apres_w
from	man_ord_serv_orc_item
where	nr_seq_orc_ordem	= nr_sequencia_p;

select	nr_seq_ordem
into STRICT	nr_seq_ordem_w
from	man_ordem_servico_orc
where	nr_sequencia	= nr_sequencia_p;

select	count(*)
into STRICT	qt_existe_w
from	unidade_medida
where	upper(cd_unidade_medida) = 'HR';

if (qt_existe_w <> 0) then
	cd_unidade_medida_w	:= 'Hr';
else
	select	max(cd_unidade_medida)
	into STRICT	cd_unidade_medida_w
	from	unidade_medida
	where	upper(ds_unidade_medida) like 'HORA%';
end if;

open c01;
loop
fetch c01 into
	ds_atividade_w,
	ds_observacao_w,
	qt_min_prev_w,
	vl_hora_unit_w,
	vl_cobranca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	insert into man_ord_serv_orc_item(NR_SEQUENCIA,
		NR_SEQ_ORC_ORDEM,
		DT_ATUALIZACAO,
		NM_USUARIO,
		NR_SEQ_APRES,
		DS_ITEM,
		QT_ITEM,
		CD_UNIDADE_MEDIDA,
		VL_UNITARIO,
		VL_ITEM,
		DS_OBSERVACAO)
	values (nextval('man_ord_serv_orc_item_seq'),
		nr_sequencia_p,
		clock_timestamp(),
		nm_usuario_p,
		NR_SEQ_APRES_w,
		substr(ds_atividade_w,1,255),
		coalesce(qt_min_prev_w,1),
		cd_unidade_medida_w,
		coalesce(vl_hora_unit_w,0),
		coalesce(vl_cobranca_w,0),
		ds_observacao_w);

	NR_SEQ_APRES_w 	:= NR_SEQ_APRES_w + 1;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_ordem_orc_item ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

