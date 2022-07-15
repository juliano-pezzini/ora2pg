-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE colunas AS (nm_coluna_w varchar(255),
						dt_registro_w	timestamp);


CREATE OR REPLACE PROCEDURE gerar_grid_ehr_elemento ( cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_elemento_p bigint, nr_seq_template_p bigint, nr_seq_temp_conteudo_p bigint, cd_profissional_p text, ie_liberado_p text, nm_usuario_p text) AS $body$
DECLARE



/* vetor */

type vetor is table of colunas index by integer;

/* globais */

vetor_w			vetor;
ivet			bigint := 0;
ind			integer;
dt_registro_w		timestamp;
nr_sequencia_w		bigint;
ds_elemento_w		varchar(255);
nr_seq_elemento_w		bigint;
qt_medida_w		double precision;
ds_valor_medida_w	varchar(500);
ds_comando_w		varchar(3000);
ds_parametro_w		varchar(3000);


ds_resultado_w		varchar(4000);
ds_resultado_ww		varchar(4000);
dt_resultado_w		timestamp;
vl_resultado_w		double precision;

nr_seq_reg_template_w	bigint;
nr_seq_temp_conteudo_w	bigint;



c01 CURSOR FOR
	SELECT	trunc(a.DT_REGISTRO) dt_laudo
	from	ehr_registro a,
			ehr_reg_template b,
			ehr_reg_elemento c
	where	a.nr_sequencia	= b.nr_seq_reg
	and		b.nr_sequencia = c.NR_SEQ_REG_TEMPLATE
	and		a.cd_paciente	= cd_pessoa_fisica_p
	and		a.dt_registro between trunc(dt_inicio_p) and fim_dia(dt_fim_p)
	and (c.nr_seq_elemento = nr_seq_elemento_p or coalesce(nr_seq_elemento_p::text, '') = '')
	and (c.NR_SEQ_TEMP_CONTEUDO = NR_SEQ_TEMP_CONTEUDO_p or coalesce(NR_SEQ_TEMP_CONTEUDO_p::text, '') = '')
	and (b.nr_seq_template = nr_seq_template_p or coalesce(nr_seq_template_p::text, '') = '')
	and (a.cd_profissional = cd_profissional_p or coalesce(cd_profissional_p::text, '') = '')
	and (ie_liberado_p = 'N' or (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> ''))
	and		coalesce(a.dt_inativacao::text, '') = ''
	group by trunc(a.DT_REGISTRO)
	order by 1 desc;

c02 CURSOR FOR
	SELECT	c.nr_seq_elemento,
			d.nm_elemento
	from	ehr_registro a,
			ehr_reg_template b,
			ehr_reg_elemento c,
			ehr_elemento d
	where	a.nr_sequencia	= b.nr_seq_reg
	and		b.nr_sequencia = c.NR_SEQ_REG_TEMPLATE
	and		d.nr_sequencia	= c.nr_seq_elemento
	and		a.cd_paciente	= cd_pessoa_fisica_p
	and		a.dt_registro between trunc(dt_inicio_p) and fim_dia(dt_fim_p)
	and (c.nr_seq_elemento = nr_seq_elemento_p or coalesce(nr_seq_elemento_p::text, '') = '')
	and (c.NR_SEQ_TEMP_CONTEUDO = NR_SEQ_TEMP_CONTEUDO_p or coalesce(NR_SEQ_TEMP_CONTEUDO_p::text, '') = '')
	and (b.nr_seq_template = nr_seq_template_p or coalesce(nr_seq_template_p::text, '') = '')
	and (a.cd_profissional = cd_profissional_p or coalesce(cd_profissional_p::text, '') = '')
	and (ie_liberado_p = 'N' or (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> ''))
	and		coalesce(a.dt_inativacao::text, '') = ''
	group by c.nr_seq_elemento,
			d.nm_elemento
	order by 2;


c03 CURSOR FOR
SELECT		c.nr_seq_reg_template,
			c.nr_seq_temp_conteudo,
			c.nr_seq_elemento
	from	ehr_registro a,
			ehr_reg_template b,
			ehr_reg_elemento c
	where	a.nr_sequencia	= b.nr_seq_reg
	and		b.nr_sequencia = c.NR_SEQ_REG_TEMPLATE
	and		a.cd_paciente	= cd_pessoa_fisica_p
	and		a.dt_registro between trunc(dt_inicio_p) and fim_dia(dt_fim_p)
	and (c.nr_seq_elemento = nr_seq_elemento_p or coalesce(nr_seq_elemento_p::text, '') = '')
	and (c.NR_SEQ_TEMP_CONTEUDO = NR_SEQ_TEMP_CONTEUDO_p or coalesce(NR_SEQ_TEMP_CONTEUDO_p::text, '') = '')
	and (b.nr_seq_template = nr_seq_template_p or coalesce(nr_seq_template_p::text, '') = '')
	and (a.cd_profissional = cd_profissional_p or coalesce(cd_profissional_p::text, '') = '')
	and		trunc(a.dt_registro) = dt_registro_w
	and (ie_liberado_p = 'N' or (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> ''))
	and		coalesce(a.dt_inativacao::text, '') = ''
	order by coalesce(ehr_vlr(c.nr_seq_reg_template,c.nr_seq_temp_conteudo),0),2;




BEGIN

delete from W_EHR_REG_ELEMENTO
where nm_usuario	= nm_usuario_p;

commit;
ivet	:= 0;
open C01;
loop
fetch C01 into
	dt_registro_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ivet := ivet + 1;
	vetor_w[ivet].nm_coluna_w 	:= dt_registro_w;
	vetor_w[ivet].dt_registro_w   	:= dt_registro_w;
	end;
end loop;
close C01;

/* completar vetor se necessário  */

ind := ivet;
while(ind < 50) loop
	begin
	ind := ind + 1;
	vetor_w[ind].nm_coluna_w := null;
	vetor_w[ind].dt_registro_w	:= null;
	end;
end loop;

select	nextval('w_ehr_reg_elemento_seq')
into STRICT	nr_sequencia_w
;

insert into W_EHR_REG_ELEMENTO(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	ie_ordem,
	ds_result1,
	ds_result2,
	ds_result3,
	ds_result4,
	ds_result5,
	ds_result6,
	ds_result7,
	ds_result8,
	ds_result9,
	ds_result10,
	ds_result11,
	ds_result12,
	ds_result13,
	ds_result14,
	ds_result15,
	ds_result16,
	ds_result17,
	ds_result18,
	ds_result19,
	ds_result20,
	ds_result21,
	ds_result22,
	ds_result23,
	ds_result24,
	ds_result25,
	ds_result26,
	ds_result27,
	ds_result28,
	ds_result29,
	ds_result30,
	ds_result31,
	ds_result32,
	ds_result33,
	ds_result34,
	ds_result35,
	ds_result36,
	ds_result37,
	ds_result38,
	ds_result39,
	ds_result40,
	ds_result41,
	ds_result42,
	ds_result43,
	ds_result44,
	ds_result45,
	ds_result46,
	ds_result47,
	ds_result48,
	ds_result49,
	ds_result50)
Values ( nr_sequencia_w,
	nm_usuario_p,
	clock_timestamp(),
	-3,
	vetor_w[1].nm_coluna_w,
	vetor_w[2].nm_coluna_w,
	vetor_w[3].nm_coluna_w,
	vetor_w[4].nm_coluna_w,
	vetor_w[5].nm_coluna_w,
	vetor_w[6].nm_coluna_w,
	vetor_w[7].nm_coluna_w,
	vetor_w[8].nm_coluna_w,
	vetor_w[9].nm_coluna_w,
	vetor_w[10].nm_coluna_w,
	vetor_w[11].nm_coluna_w,
	vetor_w[12].nm_coluna_w,
	vetor_w[13].nm_coluna_w,
	vetor_w[14].nm_coluna_w,
	vetor_w[15].nm_coluna_w,
	vetor_w[16].nm_coluna_w,
	vetor_w[17].nm_coluna_w,
	vetor_w[18].nm_coluna_w,
	vetor_w[19].nm_coluna_w,
	vetor_w[20].nm_coluna_w,
	vetor_w[21].nm_coluna_w,
	vetor_w[22].nm_coluna_w,
	vetor_w[23].nm_coluna_w,
	vetor_w[24].nm_coluna_w,
	vetor_w[25].nm_coluna_w,
	vetor_w[26].nm_coluna_w,
	vetor_w[27].nm_coluna_w,
	vetor_w[28].nm_coluna_w,
	vetor_w[29].nm_coluna_w,
	vetor_w[30].nm_coluna_w,
	vetor_w[31].nm_coluna_w,
	vetor_w[32].nm_coluna_w,
	vetor_w[33].nm_coluna_w,
	vetor_w[34].nm_coluna_w,
	vetor_w[35].nm_coluna_w,
	vetor_w[36].nm_coluna_w,
	vetor_w[37].nm_coluna_w,
	vetor_w[38].nm_coluna_w,
	vetor_w[39].nm_coluna_w,
	vetor_w[40].nm_coluna_w,
	vetor_w[41].nm_coluna_w,
	vetor_w[42].nm_coluna_w,
	vetor_w[43].nm_coluna_w,
	vetor_w[44].nm_coluna_w,
	vetor_w[45].nm_coluna_w,
	vetor_w[46].nm_coluna_w,
	vetor_w[47].nm_coluna_w,
	vetor_w[48].nm_coluna_w,
	vetor_w[49].nm_coluna_w,
	vetor_w[50].nm_coluna_w);

commit;

open C02;
loop
fetch C02 into
	nr_seq_elemento_w,
	ds_elemento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	select	nextval('w_ehr_reg_elemento_seq')
	into STRICT	nr_sequencia_w
	;
	insert into W_EHR_REG_ELEMENTO(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		ie_ordem,
		nr_seq_elemento,
		ds_elemento)
	values (	nr_sequencia_w,
		nm_usuario_p,
		clock_timestamp(),
		1,
		nr_seq_elemento_w,
		ds_elemento_w);


	end;
end loop;
close C02;


ind := 0;
while(ind < 50) loop
	begin
	ind := ind + 1;
	dt_registro_w	:= vetor_w[ind].dt_registro_w;
	open C03;
	loop
	fetch C03 into
		nr_seq_reg_template_w,
		nr_seq_temp_conteudo_w,
		nr_seq_elemento_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		ds_comando_w	:= ' update W_EHR_REG_ELEMENTO ' ||
				  ' set ds_result' || to_char(ind) ||'= :ds_valor '||
				  ' where nm_usuario = :nm_usuario ' ||
				  ' and   nr_seq_elemento = :nr_seq_elemento ';

		ds_resultado_w	:= substr(ehr_vlr(nr_seq_reg_template_w,nr_seq_temp_conteudo_w),1,255);
		ds_parametro_w	:= 'ds_valor='||coalesce(ds_resultado_w,' ')||'#@#@nm_usuario='||nm_usuario_p||'#@#@nr_seq_elemento='||nr_seq_elemento_w||'#@#@';


		CALL exec_sql_dinamico_bv('TASY', ds_comando_w,ds_parametro_w);
		end;
	end loop;
	close C03;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_grid_ehr_elemento ( cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_elemento_p bigint, nr_seq_template_p bigint, nr_seq_temp_conteudo_p bigint, cd_profissional_p text, ie_liberado_p text, nm_usuario_p text) FROM PUBLIC;

