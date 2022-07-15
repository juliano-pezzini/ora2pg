-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE conta AS (	nr_interno_conta 	bigint,
			nr_atendimento 		bigint,
			dt_entrada		timestamp,
			dt_alta			timestamp,
			dt_periodo_inicial	timestamp,
			dt_periodo_final	timestamp,
			cd_pessoa_fisica	varchar(10),
			cd_convenio_parametro	integer,
			ie_tipo_atendimento	smallint);


CREATE OR REPLACE PROCEDURE gerar_w_inf_gerencial_estagio (cd_convenio_p text, ie_tipo_acao_conv_p text, cd_categoria_p text, nr_seq_etapa_p text, ie_tipo_acao_etapa_p text, ie_tipo_atendimento_p text, ie_tipo_acao_tp_atend_p text, cd_setor_atendimento_p text, ie_tipo_acao_Setor_p text, cd_estabelecimento_p text, ie_tipo_acao_Estab_p text, nr_seq_estagio_p bigint, nr_interno_conta_p text, ie_situacao_p bigint, ie_tipo_data_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_somente_nao_audit_p text, nm_usuario_p text) AS $body$
DECLARE

type vetor_conta is table of conta index by integer;


nr_seq_pend_w		bigint;
vl_incluido_w		double precision;
vl_excluido_w		double precision;
vl_transferido_w	double precision;
qt_contas_w		bigint;
vl_receita_total_w	double precision;
vl_conta_w		double precision;
vl_receita_atual_w	double precision;
ie_integral_w		varchar(1);
vl_receita_auditoria_w	double precision;
vl_original_w		double precision;
vl_receita_sem_audit_w	double precision;
qt_media_dia_sem_audit_w double precision;
nr_conta_filtro_w	bigint;
qt_nf_w			bigint;
qt_itens_audit_w	bigint;
qt_reg_setor_filtro_w	bigint;
vl_rec_lib_fat_w	double precision;
qt_contas_lib_fat_w	bigint;
ie_tipo_estagio_w	varchar(15);
vetor_conta_w		vetor_conta;
i			integer;
k			integer;
nr_atendimento_w	bigint;
nr_seq_tipo_w		cta_pendencia.nr_seq_tipo%type;
ds_tipo_w		varchar(80);
dt_entrada_w		timestamp;
dt_alta_w		timestamp;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
nm_usuario_ult_hist_w	varchar(15);
nr_seq_hist_w		bigint;
dt_inicio_estagio_w	timestamp;
ds_estagio_w		varchar(80);
nm_pessoa_fisica_w	varchar(60);
ds_convenio_w		varchar(255);
ds_tipo_atendimento_w	varchar(100);
ie_pendencia_w		varchar(1);
vl_estagio_w		double precision;
qt_horas_estagio_w	bigint;

C00 CURSOR FOR
	SELECT	a.nr_interno_conta,
		a.nr_atendimento,
		b.dt_entrada,
		b.dt_alta,
		a.dt_periodo_inicial,
		a.dt_periodo_final,
		b.cd_pessoa_fisica,
		a.cd_convenio_parametro,
		b.ie_tipo_atendimento
	from	conta_paciente 		a,
		atendimento_paciente 	b
	where	a.nr_atendimento = b.nr_atendimento
	and	((coalesce(cd_convenio_p::text, '') = '') or  (((ie_tipo_acao_conv_p = '1') and (obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S')) or
					      ((ie_tipo_acao_conv_p = '2') and (not obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S'))))
	and	((coalesce(ie_tipo_atendimento_p::text, '') = '') or  (((ie_tipo_acao_tp_atend_p = '1') and (obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S')) or
					      ((ie_tipo_acao_tp_atend_p = '2') and (not obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S'))))
	and	((coalesce(cd_estabelecimento_p::text, '') = '') or  (((ie_tipo_acao_Estab_p = '1') and (obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S')) or
					      ((ie_tipo_acao_Estab_p = '2') and (not obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S'))))
	and 	((coalesce(nr_interno_conta_p::text, '') = '') or (obter_se_contido(a.nr_interno_conta, elimina_aspas(nr_interno_conta_p)) = 'S'))
	and 	coalesce(a.nr_seq_protocolo::text, '') = ''
	and	((coalesce(nr_seq_etapa_p::text, '') = '') or  (((ie_tipo_acao_etapa_p = '1') and (obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S')) or
					      ((ie_tipo_acao_etapa_p = '2') and (not obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S'))))
	and 	((coalesce(nr_seq_estagio_p::text, '') = '') or (exists (SELECT 	1
							from	cta_pendencia      x,
								cta_pendencia_hist y
							where	x.nr_sequencia   = y.nr_seq_pend
							and 	x.nr_interno_conta = a.nr_interno_conta
							and 	y.nr_seq_estagio =  nr_seq_estagio_p)))
	and 	((ie_situacao_p = 2) or ((ie_situacao_p = 1) and (coalesce(b.dt_alta::text, '') = '')) or (ie_situacao_p = 0 AND b.dt_alta IS NOT NULL AND b.dt_alta::text <> ''))
	and 	ie_tipo_data_p = 2
	and 	a.dt_mesano_referencia between dt_inicial_p and trunc(dt_final_p,'dd') + 86399/86400
	
union all

	select	a.nr_interno_conta,
		a.nr_atendimento,
		b.dt_entrada,
		b.dt_alta,
		a.dt_periodo_inicial,
		a.dt_periodo_final,
		b.cd_pessoa_fisica,
		a.cd_convenio_parametro,
		b.ie_tipo_atendimento
	from	conta_paciente 		a,
		atendimento_paciente 	b
	where	a.nr_atendimento = b.nr_atendimento
	and	((coalesce(cd_convenio_p::text, '') = '') or  (((ie_tipo_acao_conv_p = '1') and (obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S')) or
					      ((ie_tipo_acao_conv_p = '2') and (not obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S'))))
	and	((coalesce(ie_tipo_atendimento_p::text, '') = '') or  (((ie_tipo_acao_tp_atend_p = '1') and (obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S')) or
					      ((ie_tipo_acao_tp_atend_p = '2') and (not obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S'))))
	and	((coalesce(cd_estabelecimento_p::text, '') = '') or  (((ie_tipo_acao_Estab_p = '1') and (obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S')) or
					      ((ie_tipo_acao_Estab_p = '2') and (not obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S'))))
	and 	((coalesce(nr_interno_conta_p::text, '') = '') or (obter_se_contido(a.nr_interno_conta, elimina_aspas(nr_interno_conta_p)) = 'S'))
	and 	coalesce(a.nr_seq_protocolo::text, '') = ''
	and	((coalesce(nr_seq_etapa_p::text, '') = '') or  (((ie_tipo_acao_etapa_p = '1') and (obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S')) or
					      ((ie_tipo_acao_etapa_p = '2') and (not obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S'))))
	and 	((coalesce(nr_seq_estagio_p::text, '') = '') or (exists (select 	1
							from	cta_pendencia      x,
								cta_pendencia_hist y
							where	x.nr_sequencia   = y.nr_seq_pend
							and 	x.nr_interno_conta = a.nr_interno_conta
							and 	y.nr_seq_estagio =  nr_seq_estagio_p)))
	and 	((ie_situacao_p = 2) or ((ie_situacao_p = 1) and (coalesce(b.dt_alta::text, '') = '')) or (ie_situacao_p = 0 AND b.dt_alta IS NOT NULL AND b.dt_alta::text <> ''))
	and 	ie_tipo_data_p = 1
	and 	exists ( 	select 	1
				from 	auditoria_conta_paciente c
				where 	c.nr_interno_conta = a.nr_interno_conta
				and 	c.dt_liberacao between dt_inicial_p and trunc(dt_final_p,'dd') + 86399/86400)
	
union all

	select	a.nr_interno_conta,
		a.nr_atendimento,
		b.dt_entrada,
		b.dt_alta,
		a.dt_periodo_inicial,
		a.dt_periodo_final,
		b.cd_pessoa_fisica,
		a.cd_convenio_parametro,
		b.ie_tipo_atendimento
	from	conta_paciente 		a,
		atendimento_paciente 	b
	where	a.nr_atendimento = b.nr_atendimento
	and	((coalesce(cd_convenio_p::text, '') = '') or  (((ie_tipo_acao_conv_p = '1') and (obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S')) or
					      ((ie_tipo_acao_conv_p = '2') and (not obter_se_contido(a.cd_convenio_parametro, elimina_aspas(cd_convenio_p)) = 'S'))))
	and	((coalesce(ie_tipo_atendimento_p::text, '') = '') or  (((ie_tipo_acao_tp_atend_p = '1') and (obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S')) or
					      ((ie_tipo_acao_tp_atend_p = '2') and (not obter_se_contido(b.ie_tipo_atendimento, elimina_aspas(ie_tipo_atendimento_p)) = 'S'))))
	and	((coalesce(cd_estabelecimento_p::text, '') = '') or  (((ie_tipo_acao_Estab_p = '1') and (obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S')) or
					      ((ie_tipo_acao_Estab_p = '2') and (not obter_se_contido(a.cd_estabelecimento, elimina_aspas(cd_estabelecimento_p)) = 'S'))))
	and 	((coalesce(nr_interno_conta_p::text, '') = '') or (obter_se_contido(a.nr_interno_conta, elimina_aspas(nr_interno_conta_p)) = 'S'))
	and 	coalesce(a.nr_seq_protocolo::text, '') = ''
	and	((coalesce(nr_seq_etapa_p::text, '') = '') or  (((ie_tipo_acao_etapa_p = '1') and (obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S')) or
					      ((ie_tipo_acao_etapa_p = '2') and (not obter_se_contido(obter_ultima_etapa(a.nr_interno_conta, 'ET'), elimina_aspas(nr_seq_etapa_p)) = 'S'))))
	and 	((coalesce(nr_seq_estagio_p::text, '') = '') or (exists (select 	1
							from	cta_pendencia      x,
								cta_pendencia_hist y
							where	x.nr_sequencia   = y.nr_seq_pend
							and 	x.nr_interno_conta = a.nr_interno_conta
							and 	y.nr_seq_estagio =  nr_seq_estagio_p)))
	and 	((ie_situacao_p = 2) or ((ie_situacao_p = 1) and (coalesce(b.dt_alta::text, '') = '')) or (ie_situacao_p = 0 AND b.dt_alta IS NOT NULL AND b.dt_alta::text <> ''))
	and 	ie_tipo_data_p = 0
	and 	exists ( 	select 	1
				from 	auditoria_conta_paciente c
				where 	c.nr_interno_conta = a.nr_interno_conta
				and 	c.dt_auditoria between dt_inicial_p and trunc(dt_final_p,'dd') + 86399/86400)
	order by 1;


C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_auditoria,
		nr_seq_tipo,
		ds_complemento,
		dt_pendencia,
		dt_fechamento,
		dt_inicio_auditoria,
		dt_final_auditoria,
		nm_usuario_nrec nm_usuario_original,
		nr_seq_estagio
	from	cta_pendencia
	where	(nr_seq_auditoria IS NOT NULL AND nr_seq_auditoria::text <> '')
	and 	nr_interno_conta = nr_conta_filtro_w
	order by 1;

C02 CURSOR FOR
	SELECT	a.nr_seq_estagio,
		coalesce(sum(CASE WHEN coalesce(a.dt_final_estagio::text, '') = '' THEN  a.vl_auditoria  ELSE 0 END ),0) vl_auditoria,
		coalesce(sum(a.vl_incluido),0) vl_incluido,
		coalesce(sum(a.vl_excluido),0) vl_excluido,
		coalesce(sum(a.vl_transferido),0) vl_transferido,
		coalesce(sum(a.vl_auditoria),0) vl_audit_aux,
		coalesce(sum(CASE WHEN coalesce(a.dt_final_estagio::text, '') = '' THEN  Obter_Qt_Horas_Estagio(dt_inicio_estagio, dt_final_estagio, qt_horas_estagio)  ELSE 0 END ),0) qt_horas_estagio
	from	cta_pendencia_hist a
	where	a.nr_seq_pend = nr_seq_pend_w
	and 	((coalesce(nr_seq_estagio_p::text, '') = '') or (nr_seq_estagio = nr_seq_estagio_p))
	group by a.nr_seq_estagio
	order by 1;


C03 CURSOR FOR
	SELECT 	distinct nr_interno_conta
	from 	w_inf_gerencial_estagio
	where 	nm_usuario = nm_usuario_p;

C04 CURSOR FOR
	SELECT 	min(a.nr_sequencia) nr_seq_audit
	from 	auditoria_conta_paciente a
	where 	a.nr_interno_conta = nr_conta_filtro_w
	and 	coalesce(a.ie_integral,'N') = 'N'
	and 	exists (SELECT 	1					-- Esse and exists é para garantir que a auditoria tenha pendência vinculada.
			from 	w_inf_gerencial_estagio x
			where 	x.nr_interno_conta = a.nr_interno_conta
			and 	x.nr_seq_auditoria = a.nr_sequencia
			and 	x.nm_usuario = nm_usuario_p)
	group by a.dt_periodo_inicial,
		 a.dt_periodo_final;

c00_w	c00%rowtype;
c01_w	c01%rowtype;
c02_w	c02%rowtype;
c03_w	c03%rowtype;
c04_w	c04%rowtype;



BEGIN

CALL exec_sql_dinamico('Tasy','Truncate table w_inf_gerencial_estagio');
CALL exec_sql_dinamico('Tasy','Truncate table w_inf_gerencial_header');
CALL exec_sql_dinamico('Tasy','Truncate table w_inf_gerencial_analitico');

vl_incluido_w		:= 0;
vl_excluido_w		:= 0;
vl_transferido_w	:= 0;
vl_estagio_w		:= 0;
qt_horas_estagio_w	:= 0;


qt_contas_w		:= 0;
vl_receita_total_w	:= 0;
vl_receita_auditoria_w	:= 0;

vl_rec_lib_fat_w	:= 0;
qt_contas_lib_fat_w	:= 0;

i			:= 1;

open C00;
loop
fetch C00 into
	c00_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	vetor_conta_w[i].nr_interno_conta	:= c00_w.nr_interno_conta;
	vetor_conta_w[i].nr_atendimento		:= c00_w.nr_atendimento;
	vetor_conta_w[i].dt_entrada		:= c00_w.dt_entrada;
	vetor_conta_w[i].dt_alta		:= c00_w.dt_alta;
	vetor_conta_w[i].dt_periodo_inicial	:= c00_w.dt_periodo_inicial;
	vetor_conta_w[i].dt_periodo_final	:= c00_w.dt_periodo_final;
	vetor_conta_w[i].cd_pessoa_fisica	:= c00_w.cd_pessoa_fisica;
	vetor_conta_w[i].cd_convenio_parametro	:= c00_w.cd_convenio_parametro;
	vetor_conta_w[i].ie_tipo_atendimento	:= c00_w.ie_tipo_atendimento;
	i					:= i + 1;
	end;
end loop;
close C00;


i := vetor_conta_w.count;
for k in 1.. i loop
	begin

	nr_conta_filtro_w	:= vetor_conta_w[k].nr_interno_conta;
	nr_atendimento_w 	:= vetor_conta_w[k].nr_atendimento;
	dt_entrada_w	 	:= vetor_conta_w[k].dt_entrada;
	dt_alta_w	 	:= vetor_conta_w[k].dt_alta;
	dt_periodo_inicial_w	:= vetor_conta_w[k].dt_periodo_inicial;
	dt_periodo_final_w	:= vetor_conta_w[k].dt_periodo_final;

	select 	max(substr(obter_nome_pf(cd_pessoa_fisica),1,60))
	into STRICT	nm_pessoa_fisica_w
	from 	pessoa_fisica
	where 	cd_pessoa_fisica = vetor_conta_w[k].cd_pessoa_fisica;

	select 	max(ds_convenio)
	into STRICT	ds_convenio_w
	from 	convenio
	where 	cd_convenio = vetor_conta_w[k].cd_convenio_parametro;

	select 	obter_valor_dominio(12, vetor_conta_w[k].ie_tipo_atendimento)
	into STRICT	ds_tipo_atendimento_w
	;

	select 	count(*)
	into STRICT	qt_nf_w
	from 	nota_fiscal
	where 	nr_interno_conta = nr_conta_filtro_w;

	if (ie_somente_nao_audit_p = 'S') or (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then

		select 	sum(ie_audit),
			sum(qt_item)
		into STRICT	qt_itens_audit_w,
			qt_reg_setor_filtro_w
		from 	(SELECT sum(CASE WHEN ie_auditoria='S' THEN  0  ELSE 1 END ) ie_audit,
				count(*) qt_item
			from 	procedimento_paciente
			where 	nr_interno_conta = nr_conta_filtro_w
			and	((coalesce(cd_setor_atendimento_p::text, '') = '') or  (((ie_tipo_acao_Setor_p = '1') and (obter_se_contido(cd_setor_atendimento, elimina_aspas(cd_setor_atendimento_p)) = 'S')) or
									((ie_tipo_acao_Setor_p = '2') and (not obter_se_contido(cd_setor_atendimento, elimina_aspas(cd_setor_atendimento_p)) = 'S'))))
			
union all

			SELECT  sum(CASE WHEN ie_auditoria='S' THEN  0  ELSE 1 END ) ie_audit,
				count(*) qt_item
			from 	material_atend_paciente
			where 	nr_interno_conta = nr_conta_filtro_w
			and	((coalesce(cd_setor_atendimento_p::text, '') = '') or  (((ie_tipo_acao_Setor_p = '1') and (obter_se_contido(cd_setor_atendimento, elimina_aspas(cd_setor_atendimento_p)) = 'S')) or
									((ie_tipo_acao_Setor_p = '2') and (not obter_se_contido(cd_setor_atendimento, elimina_aspas(cd_setor_atendimento_p)) = 'S'))))
			) alias36;
	end if;


	if (qt_nf_w = 0) and
		((coalesce(cd_setor_atendimento_p::text, '') = '') or (qt_reg_setor_filtro_w > 0)) and
		((ie_somente_nao_audit_p = 'S' AND qt_itens_audit_w > 0) or (ie_somente_nao_audit_p = 'N')) then

		ie_pendencia_w := 'N';
		open C01;
		loop
		fetch C01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			ie_pendencia_w := 'S';
			nr_seq_pend_w	  := c01_w.nr_sequencia;

			select 	max(ds_tipo)
			into STRICT	ds_tipo_w
			from 	cta_tipo_pend
			where 	nr_sequencia = c01_w.nr_seq_tipo;

			select 	max(ds_estagio)
			into STRICT	ds_estagio_w
			from 	cta_estagio_pend
			where 	nr_sequencia = c01_w.nr_seq_estagio;


			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_hist_w
			from 	cta_pendencia_hist
			where 	nr_seq_pend = nr_seq_pend_w;

			begin
			if (nr_seq_hist_w > 0) then

				select 	dt_inicio_estagio,
					nm_usuario_nrec
				into STRICT	dt_inicio_estagio_w,
					nm_usuario_ult_hist_w
				from 	cta_pendencia_hist
				where 	nr_sequencia = nr_seq_hist_w;

			else

				select 	dt_pendencia,
					nm_usuario_nrec
				into STRICT	dt_inicio_estagio_w,
					nm_usuario_ult_hist_w
				from 	cta_pendencia
				where 	nr_sequencia = nr_seq_pend_w;

			end if;
			exception
				when others then
					dt_inicio_estagio_w	:= null;
					nm_usuario_ult_hist_w	:= null;
				end;


			vl_estagio_w:= 0;
			qt_horas_estagio_w:= 0;

			open C02;
			loop
			fetch C02 into
				c02_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				select 	coalesce(max(ie_tipo_estagio),'A')
				into STRICT	ie_tipo_estagio_w
				from 	cta_estagio_pend
				where 	nr_sequencia = c02_w.nr_seq_estagio;

				if (ie_tipo_estagio_w = 'F') then

					vl_rec_lib_fat_w	:= 	vl_rec_lib_fat_w + c02_w.vl_audit_aux;
					qt_contas_lib_fat_w	:= 	qt_contas_lib_fat_w + 1;

				end if;

				vl_estagio_w:= vl_estagio_w + c02_w.vl_auditoria;
				qt_horas_estagio_w:= qt_horas_estagio_w + c02_w.qt_horas_estagio;

				vl_incluido_w	:= vl_incluido_w + c02_w.vl_incluido;
				vl_excluido_w	:= vl_excluido_w + c02_w.vl_excluido;
				vl_transferido_w:= vl_transferido_w + c02_w.vl_transferido;

				insert 	into w_inf_gerencial_estagio(
							nr_interno_conta,
							nr_seq_auditoria,
							nr_Seq_pendencia,
							nr_seq_estagio,
							vl_estagio_audit,
							vl_incluido,
							vl_excluido,
							vl_transferido,
							nm_usuario,
							dt_atualizacao,
							qt_horas_estagio)
						values (nr_conta_filtro_w,
							c01_w.nr_seq_auditoria,
							c01_w.nr_sequencia,
							c02_w.nr_seq_estagio,
							c02_w.vl_auditoria,
							c02_w.vl_incluido,
							c02_w.vl_excluido,
							c02_w.vl_transferido,
							nm_usuario_p,
							clock_timestamp(),
							c02_w.qt_horas_estagio);
				end;
			end loop;
			close C02;

			-- Gravar dados Analítico quando tem pendência
			insert into w_inf_gerencial_analitico(
					nr_atendimento,
					nr_interno_conta,
					ds_tipo,
					ds_estagio,
					dt_pendencia,
					dt_fechamento,
					nm_pessoa_fisica,
					dt_entrada,
					dt_alta,
					ds_convenio,
					ds_tipo_atendimento,
					nm_usuario_original,
					nm_usuario_nrec,
					dt_inicio_estagio,
					ds_complemento,
					dt_inicio_auditoria,
					dt_final_auditoria,
					nr_seq_auditoria,
					dt_periodo_inicial,
					dt_periodo_final,
					dt_atualizacao,
					nm_usuario,
					vl_conta,
					vl_auditoria,
					vl_estagio,
					nr_seq_estagio,
					nr_seq_tipo,
					qt_horas_estagio)
				values (
					nr_atendimento_w,
					nr_conta_filtro_w,
					ds_tipo_w,
					ds_estagio_w,
					c01_w.dt_pendencia,
					c01_w.dt_fechamento,
					nm_pessoa_fisica_w,
					dt_entrada_w,
					dt_alta_w,
					ds_convenio_w,
					ds_tipo_atendimento_w,
					c01_w.nm_usuario_original,
					nm_usuario_ult_hist_w,
					dt_inicio_estagio_w,
					c01_w.ds_complemento,
					c01_w.dt_inicio_auditoria,
					c01_w.dt_final_auditoria,
					c01_w.nr_seq_auditoria,
					dt_periodo_inicial_w,
					dt_periodo_inicial_w,
					clock_timestamp(),
					nm_usuario_p,
					0,
					0,
					vl_estagio_w,
					c01_w.nr_seq_estagio,
					c01_w.nr_seq_tipo,
					qt_horas_estagio_w);

			end;
		end loop;
		close C01;

		qt_contas_w:= qt_contas_w + 1;

		select 	coalesce(sum(vl_item),0)
		into STRICT	vl_conta_w
		from (SELECT  coalesce(sum(vl_material),0) vl_item
			from 	material_atend_paciente
			where 	nr_interno_conta = nr_conta_filtro_w
			and 	coalesce(cd_motivo_exc_conta::text, '') = ''
			and	coalesce(nr_seq_proc_pacote,0) <> nr_sequencia
			
union all

			SELECT  coalesce(sum(vl_procedimento),0) vl_item
			from 	procedimento_paciente
			where 	nr_interno_conta = nr_conta_filtro_w
			and 	coalesce(cd_motivo_exc_conta::text, '') = ''
			and	coalesce(nr_seq_proc_pacote,0) <> nr_sequencia) alias10;

		vl_receita_total_w:= vl_receita_total_w + vl_conta_w;

		open C04;
		loop
		fetch C04 into
			c04_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin

			/*select 	nvl(sum(Obter_valor_Orig_Audit(c04_w.nr_seq_audit)),0)
			into	vl_original_w -- Valor original
			from 	dual;*/
			select 	coalesce(sum(vl_auditoria_orig),0)
			into STRICT	vl_original_w
			from 	auditoria_conta_paciente
			where 	nr_sequencia = c04_w.nr_seq_audit;

			vl_receita_auditoria_w:= vl_receita_auditoria_w + vl_original_w;

			update 	w_inf_gerencial_analitico
			set 	vl_auditoria = coalesce(vl_original_w,0)
			where	nr_interno_conta = nr_conta_filtro_w
			and 	nm_usuario = nm_usuario_p
			and 	nr_seq_auditoria = c04_w.nr_seq_audit;

			end;
		end loop;
		close C04;

		if (ie_pendencia_w = 'S') then

			update 	w_inf_gerencial_analitico
			set 	vl_conta = coalesce(vl_conta_w,0)
			where	nr_interno_conta = nr_conta_filtro_w
			and 	nm_usuario = nm_usuario_p;

		else

			-- Gravar dados Analítico quando NÃO TEM PENDÊNCIA
			insert into w_inf_gerencial_analitico(
					nr_atendimento,
					nr_interno_conta,
					ds_tipo,
					ds_estagio,
					dt_pendencia,
					dt_fechamento,
					nm_pessoa_fisica,
					dt_entrada,
					dt_alta,
					ds_convenio,
					ds_tipo_atendimento,
					nm_usuario_original,
					nm_usuario_nrec,
					dt_inicio_estagio,
					ds_complemento,
					dt_inicio_auditoria,
					dt_final_auditoria,
					nr_seq_auditoria,
					dt_periodo_inicial,
					dt_periodo_final,
					dt_atualizacao,
					nm_usuario,
					vl_conta,
					vl_auditoria,
					vl_estagio,
					nr_seq_estagio,
					nr_seq_tipo,
					qt_horas_estagio)
				values (
					nr_atendimento_w,
					nr_conta_filtro_w,
					null,
					null,
					null,
					null,
					nm_pessoa_fisica_w,
					dt_entrada_w,
					dt_alta_w,
					ds_convenio_w,
					ds_tipo_atendimento_w,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					dt_periodo_inicial_w,
					dt_periodo_final_w,
					clock_timestamp(),
					nm_usuario_p,
					vl_conta_w,
					0,
					0,
					null,
					null,
					0);

		end if;


	end if;


	end;
end loop;

--vl_receita_atual_w	:= vl_receita_auditoria_w + vl_incluido_w  + vl_excluido_w;
vl_receita_atual_w	:= vl_receita_auditoria_w + vl_incluido_w  + vl_excluido_w - vl_transferido_w;
vl_receita_sem_audit_w	:= vl_receita_total_w -  vl_receita_atual_w;
qt_media_dia_sem_audit_w:= (dividir(vl_receita_sem_audit_w, vl_receita_total_w)) * 30;

/*
Gerar w_inf_gerencial_header*/
insert 	into w_inf_gerencial_header(
		vl_receita_total,
		vl_receita_auditoria,
		vl_receita_sem_audit,
		vl_inclusao,
		vl_exclusao,
		vl_transferido,
		vl_receita_atual,
		qt_media_dia_sem_audit,
		qt_contas,
		nm_usuario,
		dt_atualizacao,
		vl_rec_lib_fat,
		qt_contas_lib_fat)
	values (vl_receita_total_w,
		 vl_receita_auditoria_w,
		 vl_receita_sem_audit_w,
		 vl_incluido_w,
		 vl_excluido_w,
		 vl_transferido_w,
		 vl_receita_atual_w,
		 qt_media_dia_sem_audit_w,
		 qt_contas_w,
		 nm_usuario_p,
		 clock_timestamp(),
		 vl_rec_lib_fat_w,
		 qt_contas_lib_fat_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_inf_gerencial_estagio (cd_convenio_p text, ie_tipo_acao_conv_p text, cd_categoria_p text, nr_seq_etapa_p text, ie_tipo_acao_etapa_p text, ie_tipo_atendimento_p text, ie_tipo_acao_tp_atend_p text, cd_setor_atendimento_p text, ie_tipo_acao_Setor_p text, cd_estabelecimento_p text, ie_tipo_acao_Estab_p text, nr_seq_estagio_p bigint, nr_interno_conta_p text, ie_situacao_p bigint, ie_tipo_data_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_somente_nao_audit_p text, nm_usuario_p text) FROM PUBLIC;

