-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_exames_compl ( nm_usuario_p text, nr_seq_aval_pre_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
qt_dado_w		varchar(160);
vl_parametro_w		varchar(255);
nr_seq_dado_estat_w	bigint;
nr_seq_apresentacao_w	bigint;
nr_seq_exame_w		bigint;
nr_prescricao_w		bigint;
nr_seq_prescr_w		bigint;
dt_baixa_w			timestamp;
dt_prev_execucao_w  timestamp;
cd_estabelecimento_w	bigint;
vl_param_61_w 		varchar(255);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_apresentacao,
		nr_seq_exame
	from	apa_dado_estat a
	where	ie_situacao 	=	'A'
	and ((a.cd_estabelecimento = cd_estabelecimento_w) or (coalesce(a.cd_estabelecimento::text, '') = ''))
	and	cd_empresa	=	cd_empresa_p
	and	not exists (	SELECT	1
				from	aval_pre_anest_dado_estat b
				where	b.nr_seq_tipo_dado	=	a.nr_sequencia
				and	b.nr_seq_aval_pre	=	nr_seq_aval_pre_p
				and   coalesce(b.dt_inativacao::text, '') = '');


BEGIN

cd_estabelecimento_w := coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento);

vl_parametro_w := obter_param_usuario(874, 2, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_w, vl_parametro_w);

vl_param_61_w := obter_param_usuario(874, 61, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_w, vl_param_61_w);


open C01;
loop
fetch C01 into	
	nr_seq_dado_estat_w,
	nr_seq_apresentacao_w,
	nr_seq_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	

	qt_dado_w	:= null;

	if (vl_parametro_w = 'S') then
		begin		
		
		select	cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	aval_pre_anestesica
		where	nr_sequencia = nr_seq_aval_pre_p;

		select	max(nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_medica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;

		if (vl_param_61_w = 'S')then
		
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_medica a
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and exists (SELECT  1
						from    exame_lab_resultado d,
								exame_lab_result_item c
						where	d.nr_seq_resultado = c.nr_seq_resultado
						and	c.nr_seq_exame     = nr_seq_exame_w
						and	d.nr_prescricao	   = a.nr_prescricao);
		end if;
		
		select	coalesce(max(c.nr_seq_prescr),0)
		into STRICT	nr_seq_prescr_w
		from    exame_lab_resultado d,
		        exame_lab_result_item c
		where	d.nr_seq_resultado = c.nr_seq_resultado
		and	c.nr_seq_exame     = nr_seq_exame_w
		and	d.nr_prescricao	   = nr_prescricao_w;

		select	obter_valor_ds_resultado_exame(nr_seq_exame_w, nr_seq_prescr_w, nr_prescricao_w, 'V')
		into STRICT	qt_dado_w
		;
		
		select max(dt_baixa),
			   max(dt_prev_execucao)
		into STRICT   dt_baixa_w,
			   dt_prev_execucao_w
		from   prescr_procedimento
		where  nr_prescricao =  nr_prescricao_w
		and	   nr_sequencia  =  nr_seq_prescr_w;
			
		end;
	end if;

	insert into aval_pre_anest_dado_estat(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_tipo_dado,
		nr_seq_apresentacao,
		nr_seq_aval_pre,
		qt_dado,
		dt_exame,
		ie_situacao)
	values (nextval('aval_pre_anest_dado_estat_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_dado_estat_w,
		nr_seq_apresentacao_w,
		nr_seq_aval_pre_p,
		qt_dado_w,
		coalesce(dt_baixa_w,dt_prev_execucao_w),
		'A');
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_exames_compl ( nm_usuario_p text, nr_seq_aval_pre_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

