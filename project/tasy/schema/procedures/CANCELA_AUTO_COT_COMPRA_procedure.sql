-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancela_auto_cot_compra ( cd_estabelecimento_p bigint, dt_parametro_p timestamp, dias_aberta_p bigint, nr_seq_motivo_cancel_p bigint ) AS $body$
DECLARE



nr_cot_compra_w	cot_compra.nr_cot_compra%type;

c01 CURSOR FOR
SELECT nr_cot_compra
from cot_compra a
where a.dt_cot_compra < (dt_parametro_p - dias_aberta_p)
and coalesce(a.dt_aprovacao::text, '') = ''
and coalesce(a.nr_seq_motivo_cancel::text, '') = ''
and a.cd_estabelecimento = cd_estabelecimento_p
and coalesce(a.dt_calculo_cotacao::text, '') = ''
and (coalesce(a.dt_geracao_ordem_compra::text, '') = ''
or (obter_se_cancela_cotacao(a.nr_cot_compra)) = 'S')
and not exists ( select 1
                 from cot_compra_forn_item b
                 where b.nr_cot_compra = a.nr_cot_compra
                 and coalesce(vl_unitario_material,0) > 0 )
and not exists ( select 1
                from cot_compra_item c
                where c.nr_cot_compra = a.nr_cot_compra
                and obter_bloq_canc_proj_rec(c.nr_seq_proj_rec) > 0 );



BEGIN

open c01;
loop
fetch c01 into
	nr_cot_compra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin

	update cot_compra
	set	ds_observacao = wheb_mensagem_pck.get_texto(1201245,'DIAS_ABERTA_P=' || dias_aberta_p),
        nr_seq_motivo_cancel = nr_seq_motivo_cancel_p,
        dt_atualizacao = clock_timestamp()
	where nr_cot_compra = nr_cot_compra_w;

	insert into cot_compra_hist(
	        nr_sequencia,
	        nr_cot_compra,
	        dt_atualizacao,
	        nm_usuario,
	        dt_historico,
	        ds_titulo,
	        ds_historico,
	        dt_atualizacao_nrec,
	        nm_usuario_nrec,
	        ie_tipo,
	        ie_origem)
	values (	nextval('cot_compra_hist_seq'),
	        nr_cot_compra_w,
	        clock_timestamp(),
	        'Tasy',
	        clock_timestamp(),
	        Wheb_mensagem_pck.get_Texto(147174),
	        Wheb_mensagem_pck.get_Texto(1201246 ),
	        clock_timestamp(),
	        'Tasy',
	        'S',
	        'H');

	end;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancela_auto_cot_compra ( cd_estabelecimento_p bigint, dt_parametro_p timestamp, dias_aberta_p bigint, nr_seq_motivo_cancel_p bigint ) FROM PUBLIC;

