-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_desp_viagem_mes ( dt_mes_p timestamp, nm_usuario_p text) AS $body$
DECLARE


cd_executor_w				varchar(10);
nr_seq_desp_viagem_mes_w		proj_desp_viagem_mes.nr_sequencia%type;


/*cursor c01 is
select	a.cd_pessoa_fisica
from	com_canal_consultor_v a
where	a.ie_situacao		= 'A'
and	exists(	select	1
		from	via_relat_desp z,
			via_viagem y
		where	y.cd_pessoa_fisica		= a.cd_pessoa_fisica
		and 	z.NR_SEQ_viagem = y.nr_sequencia
		and	z.nr_seq_fech_proj is null
		and     z.dt_aprovacao is not null
		and	y.NR_SEQ_MOTIVO_CANCEL is null)
and 	not exists
		( select 1
		from   	 proj_desp_viagem_mes h
		where  	 h.cd_pessoa_fisica = a.cd_pessoa_fisica
		and	 h.dt_mes = dt_mes_p); */
c01 CURSOR FOR
SELECT	y.cd_pessoa_fisica
from	via_relat_desp z,
	via_viagem y
where	z.NR_SEQ_viagem = y.nr_sequencia
and	coalesce(z.nr_seq_fech_proj::text, '') = ''
and     (z.dt_aprovacao IS NOT NULL AND z.dt_aprovacao::text <> '')
and	coalesce(y.nr_seq_motivo_cancel::text, '') = ''
and 	not exists ( select	1
		    from	proj_desp_viagem_mes h
		    where	h.cd_pessoa_fisica = y.cd_pessoa_fisica
		    and		trunc(h.dt_mes) = trunc(dt_mes_p))
group by y.cd_pessoa_fisica;


c02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_fech_proj
	FROM 	via_relat_desp a,
		via_viagem b
	WHERE 	a.nr_seq_viagem = b.nr_sequencia
	AND 	b.cd_pessoa_fisica = cd_executor_w
	AND 	coalesce(a.nr_seq_fech_proj::text, '') = ''
	AND 	(a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '');

c02_w	c02%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	cd_executor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	SELECT 	nextval('proj_desp_viagem_mes_seq')
	INTO STRICT 	nr_seq_desp_viagem_mes_w
	;

	insert into proj_desp_viagem_mes(
				NR_SEQUENCIA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				DT_MES,
				DT_GERACAO,
				CD_PESSOA_FISICA,
				VL_TOTAL_PAGAR)
			values (nr_seq_desp_viagem_mes_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				dt_mes_p,
				clock_timestamp(),
				cd_executor_w,
				0);

	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL proj_vincular_desp_viagem(	c02_w.nr_sequencia,
						nr_seq_desp_viagem_mes_w,
						nm_usuario_p);
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_desp_viagem_mes ( dt_mes_p timestamp, nm_usuario_p text) FROM PUBLIC;
