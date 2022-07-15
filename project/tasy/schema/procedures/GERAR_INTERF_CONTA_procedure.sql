-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_conta ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type) AS $body$
DECLARE


nr_seq_protocolo_w			protocolo_convenio.nr_seq_protocolo%type := 0;
nr_seq_envio_convenio_w		bigint		:= 0;
dt_mesano_referencia_w		protocolo_convenio.dt_mesano_referencia%type;
dt_vencimento_w			timestamp;
cd_convenio_w				convenio.cd_convenio%type := 0;
cd_cgc_hospital_w			varchar(14);
nm_hospital_w				varchar(80);
ds_convenio_w				varchar(255);
cd_cgc_convenio_w			varchar(14);
cd_interno_w				varchar(15);
cd_regional_w				varchar(15);
nr_sequencia_w			bigint		:= 0;
nr_interno_conta_w			bigint		:= 0;
nr_atendimento_w			bigint		:= 0;
ie_tipo_protocolo_w			smallint		:= 0;
ie_tipo_atendimento_w		smallint		:= 0;
ie_excluir_hon_med_w			varchar(1);
ie_excluir_hon_terc_w		varchar(1);
qt_itens_conta_w			bigint		:= 0;
nr_seq_registro_w			bigint		:= 0;
vl_material_w				double precision		:= 0;
nr_protocolo_w			varchar(40);
dt_inicio_protocolo_w		timestamp;
dt_fim_protocolo_w			timestamp;
nr_primeira_guia_w			varchar(10);
nr_ultima_guia_w			varchar(10);
qt_guia_w				integer := 0;	
ie_agrup_item_interf_w		varchar(1);
w_tot_trailler_w			integer := 0;
qt_documento_w			integer;
vl_procedimento_w			double precision;
nm_usuario_w			varchar(15);
vl_protocolo_w 			protocolo_convenio.vl_recebimento%type;
qt_conta_w 				integer;
ds_sigla_moeda_w		moeda.ds_sigla_moeda%type;

nr_nota_inicial_w		numeric(38);
ie_controla_nota_conta_ipe_w	parametro_faturamento.ie_controla_nota_conta_ipe%type;

c01 CURSOR FOR
	SELECT	a.nr_interno_conta,
		a.nr_atendimento,
		b.ie_tipo_atendimento
	from	conta_paciente a,
		atendimento_paciente b
	where	a.nr_atendimento	= b.nr_atendimento
	and 	a.nr_seq_protocolo	= nr_seq_protocolo_p
	and	coalesce(a.ie_cancelamento::text, '') = ''
	order by 1;

type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w	vetor;

BEGIN

/* Limpar tabelas transitorias */

delete from w_interf_conta_header
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_cab
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_autor
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_item
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_item_ipe
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_total
where nr_seq_protocolo	= nr_seq_protocolo_p;
delete from w_interf_conta_trailler
where nr_seq_protocolo	= nr_seq_protocolo_p;

commit;

delete from w_interf_conta_cab
where nr_interno_conta in (	SELECT nr_interno_conta
				from conta_paciente
				where nr_seq_protocolo = nr_seq_protocolo_p);
delete from w_interf_conta_autor
where nr_interno_conta in (	SELECT nr_interno_conta
				from conta_paciente
				where nr_seq_protocolo = nr_seq_protocolo_p);
delete from w_interf_conta_item
where nr_interno_conta in (	SELECT nr_interno_conta
				from conta_paciente
				where nr_seq_protocolo = nr_seq_protocolo_p);
delete from w_interf_conta_total
where nr_interno_conta in (	SELECT nr_interno_conta
				from conta_paciente
				where nr_seq_protocolo = nr_seq_protocolo_p);
delete from w_interf_conta_item_ipe
where nr_interno_conta in (	SELECT nr_interno_conta
				from conta_paciente
				where nr_seq_protocolo = nr_seq_protocolo_p);
commit;

/* Tratar registro tipo HEADER */


/* Buscar sequence */

select	nextval('w_interf_conta_header_seq')
into STRICT	nr_sequencia_w
;

/* Dados do protocolo */

select	a.nr_seq_protocolo,
	mod(a.nr_seq_envio_convenio, coalesce(nr_multiplo_envio,0)),
	a.dt_mesano_referencia,
	a.dt_vencimento,
	a.cd_convenio,
	a.ie_tipo_protocolo,
	a.nr_protocolo,
	a.dt_periodo_inicial,
	a.dt_periodo_final,
	coalesce(somente_numero(nr_seq_doc_convenio),0),
	coalesce(a.nm_usuario_envio,a.nm_usuario),
	a.vl_recebimento
into STRICT	nr_seq_protocolo_w,
	nr_seq_envio_convenio_w,
	dt_mesano_referencia_w,
	dt_vencimento_w,
	cd_convenio_w,
	ie_tipo_protocolo_w,
	nr_protocolo_w,
	dt_inicio_protocolo_w,
	dt_fim_protocolo_w,
	nr_nota_inicial_w,
	nm_usuario_w,
	vl_protocolo_w
from	convenio b,
	protocolo_convenio a
where	a.cd_convenio		= b.cd_convenio
and	a.nr_seq_protocolo	= nr_seq_protocolo_p;
/* Dados do estabelecimento */

select	a.cd_cgc,
	elimina_acentuacao(b.ds_razao_social)
into STRICT	cd_cgc_hospital_w,
	nm_hospital_w
from	estabelecimento a,
	pessoa_juridica b
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	b.cd_cgc		= a.cd_cgc;
/* Parametros de Faturamento*/

begin
select	coalesce(ie_controla_nota_conta_ipe,'N')
into STRICT	ie_controla_nota_conta_ipe_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_p  LIMIT 1;
exception
when others then
	ie_controla_nota_conta_ipe_w := 'N';
end;
/* Dados do convenio */

select	elimina_acentuacao(ds_convenio),
	cd_cgc,
	obter_valor_conv_estab(cd_convenio, cd_estabelecimento_p, 'CD_INTERNO'),
	obter_valor_conv_estab(cd_convenio, cd_estabelecimento_p, 'CD_REGIONAL'),
	ie_agrup_item_interf
into STRICT	ds_convenio_w,
	cd_cgc_convenio_w,
	cd_interno_w,
	cd_regional_w,
	ie_agrup_item_interf_w
from	convenio
where	cd_convenio	= cd_convenio_w;
/* Chamada especial do convenio IPE */

if (ie_agrup_item_interf_w in ('E','G')) then
	begin
	delete from w_interf_conta_item_ipe
	where nr_seq_protocolo	= nr_seq_protocolo_p;
	commit;
	end;
end if;

/* selecionar as contas do protocolo */

open c01;
loop
fetch c01 bulk collect into s_array limit 100000;
	vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

select 	max(a.ds_sigla_moeda)
into STRICT 	ds_sigla_moeda_w
from  moeda a,
      empresa b,
      estabelecimento c
where c.cd_empresa = b.cd_empresa
and   b.cd_moeda_ref = a.cd_moeda
and   c.cd_estabelecimento = cd_estabelecimento_p;

begin
qt_conta_w := vetor_c01_w.count;
end;
/* Gravar conta_header */

insert into w_interf_conta_header(
	nr_sequencia,
	cd_tipo_registro,
	nr_seq_registro,
	nr_seq_interface,
	cd_interno,
	cd_regional,
	nm_convenio,
	cd_cgc_convenio,
	nm_hospital,
	cd_cgc_hospital,
	nr_remessa,
	dt_remessa,
	dt_vencimento,
	nr_seq_protocolo,
	cd_convenio,
	ie_tipo_protocolo,
	nr_protocolo,
	dt_inicio_protocolo,
	dt_fim_protocolo,
	vl_protocolo,
	qt_contas,
	ds_sigla_moeda)
values (	nr_sequencia_w,
	0,
	1,
	1,
	cd_interno_w,
	cd_regional_w,
	ds_convenio_w,
	cd_cgc_convenio_w,
	nm_hospital_w,
	cd_cgc_hospital_w,
	nr_seq_envio_convenio_w,
	dt_mesano_referencia_w,
	dt_vencimento_w,
	nr_seq_protocolo_p,
	cd_convenio_w,
	ie_tipo_protocolo_w,
	nr_protocolo_w,
	dt_inicio_protocolo_w,
	dt_fim_protocolo_w,
	vl_protocolo_w,
	qt_conta_w,
	ds_sigla_moeda_w);

commit;

for i in 1..vetor_c01_w.count loop
	begin
	s_array := vetor_c01_w(i);
	for z in 1..s_array.count loop
		begin

		nr_interno_conta_w	:= s_array[z].nr_interno_conta;
		nr_atendimento_w	:= s_array[z].nr_atendimento;
		ie_tipo_atendimento_w	:= s_array[z].ie_tipo_atendimento;
		/* selecionar regra de exclusao de honorarios */


		/* IE_EXCLUIR_HON_MED exclui regra honorario direto do medico 'M' */


		/* IE_EXCLUIR_HON_TERC exclui regra honorario terceiros 'COOP' */

		begin
		select	coalesce(ie_excluir_hon_med,'N'),
			coalesce(ie_excluir_hon_terc,'N')
		into STRICT	ie_excluir_hon_med_w,
			ie_excluir_hon_terc_w
		from	param_interface
		where	cd_convenio = cd_convenio_w
		and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w) = ie_tipo_atendimento_w
		and	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;
		exception
		when others then
			begin
			ie_excluir_hon_med_w	:= 'N';
			ie_excluir_hon_terc_w	:= 'N';
			end;
		end;
						
		if (ie_controla_nota_conta_ipe_w = 'S') and
			((ie_tipo_protocolo_w = 1) or (ie_tipo_atendimento_w = 8)) then
			begin
			CALL gerar_nota_conta_convenio(nr_seq_protocolo_p,cd_convenio_w,nm_usuario_w);
			end;
		end if;

		nr_sequencia_w := gerar_interf_conta_cab(	nr_seq_protocolo_p, nr_seq_envio_convenio_w, cd_convenio_w, nr_atendimento_w, nr_interno_conta_w, cd_cgc_hospital_w, cd_cgc_convenio_w, cd_interno_w, nr_sequencia_w);

		nr_seq_registro_w	:= nr_seq_registro_w + 1;

		update w_interf_conta_cab
		set nr_seq_registro	= nr_seq_registro_w
		where nr_sequencia	= nr_sequencia_w;

		CALL gerar_interf_conta_aut( nr_seq_protocolo_p,
					nr_seq_envio_convenio_w,
					cd_convenio_w,
					nr_atendimento_w,
					nr_interno_conta_w,
					cd_cgc_hospital_w,
					cd_cgc_convenio_w,
					cd_interno_w);

		CALL gerar_interf_conta_item(nr_seq_protocolo_p,
					nr_seq_envio_convenio_w,
					cd_convenio_w,
					nr_atendimento_w,
					nr_interno_conta_w,
					cd_cgc_hospital_w,
					cd_cgc_convenio_w,
					cd_interno_w,
					ie_excluir_hon_med_w,
					ie_excluir_hon_terc_w);

		/* Chamada especial do convenio IPE - Internados */

		if (ie_agrup_item_interf_w = 'E') and (not ie_tipo_atendimento_w in (7,3)) and
			((nr_nota_inicial_w = 0) 	or (ie_tipo_protocolo_w = 1))	then
			CALL gerar_interf_conta_item_ipe(nr_seq_protocolo_p,nr_interno_conta_w);
		end if;
		/* IPE - Global  OS*/

		if (ie_agrup_item_interf_w = 'G') and
			((nr_nota_inicial_w = 0) 	or (ie_tipo_protocolo_w = 1))	then
			CALL gerar_interf_conta_ipe_global(nr_seq_protocolo_p,nr_interno_conta_w);
		end if;

		CALL gerar_interf_conta_total(	nr_seq_protocolo_p,
						nr_seq_envio_convenio_w,
						cd_convenio_w,
						nr_atendimento_w,
						nr_interno_conta_w,
						cd_cgc_hospital_w,
						cd_cgc_convenio_w,
						cd_interno_w,
		 	 			ie_excluir_hon_med_w,
			 			ie_excluir_hon_terc_w);


		/* Excluir contas sem item - excluidos pela regra honorarios */

		begin
		qt_itens_conta_w	:= 0;

		Select	count(1)
		into STRICT	qt_itens_conta_w
		from	w_interf_conta_item
		where	nr_interno_conta	= nr_interno_conta_w  LIMIT 1;
		exception
			when others then
			qt_itens_conta_w := 0;
		end;

		if (qt_itens_conta_w = 0) then
			begin
			delete from w_interf_conta_cab
			where nr_interno_conta	= nr_interno_conta_w;
			delete from w_interf_conta_autor
			where nr_interno_conta	= nr_interno_conta_w;
			delete from w_interf_conta_item
			where nr_interno_conta	= nr_interno_conta_w;
			delete from w_interf_conta_total
			where nr_interno_conta	= nr_interno_conta_w;
			end;
		end if;

		commit;

		end;
	end loop;
	end;
end loop;

commit;

/* Chamada especial do convenio IPE - Exames */

if (ie_agrup_item_interf_w in ('E','G')) and
	((nr_nota_inicial_w > 0) or (ie_controla_nota_conta_ipe_w = 'S'))	 and (ie_tipo_atendimento_w	= 7)	 then
	CALL gerar_interf_item_exames_ipe(nr_seq_protocolo_p);
	commit;
end if;
/* Chamada especial do convenio IPE - PA */

if (ie_agrup_item_interf_w in ('E','G')) 	and
	((nr_nota_inicial_w > 0) or (ie_controla_nota_conta_ipe_w = 'S')) and (ie_tipo_atendimento_w in (3,8))	then
	gerar_interf_item_pa_ipe(nr_seq_protocolo_p);
	commit;
end if;

/* Tratar registro tipo TRAILLER */


/* Buscar sequence */

select	nextval('w_interf_conta_trailler_seq')
into STRICT	nr_sequencia_w
;

select 	coalesce(sum(vl_material),0)
into STRICT 	vl_material_w
from 	material_atend_paciente b,
	conta_paciente a
where 	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_seq_protocolo	= nr_seq_protocolo_p
and	CASE WHEN coalesce(b.nr_seq_proc_pacote::text, '') = '' THEN b.nr_sequencia  ELSE b.nr_seq_proc_pacote END  = b.nr_sequencia
and	coalesce(a.ie_cancelamento::text, '') = '';

begin
select	coalesce(a.cd_autorizacao,'0')
into STRICT	nr_primeira_guia_w
from	w_interf_conta_autor a
where	a.nr_seq_protocolo	= nr_seq_protocolo_p
and	a.nr_interno_conta	= (SELECT min(x.nr_interno_conta)
				from	w_interf_conta_autor x
				where	x.nr_seq_protocolo = nr_seq_protocolo_p);
exception
	when others then
	nr_primeira_guia_w := '0';
end;

begin
select	coalesce(a.cd_autorizacao,'0')
into STRICT	nr_ultima_guia_w
from	w_interf_conta_autor a
where	a.nr_seq_protocolo	= nr_seq_protocolo_p
and	a.nr_interno_conta	= (SELECT max(x.nr_interno_conta)
				from	w_interf_conta_autor x
				where	x.nr_seq_protocolo = nr_seq_protocolo_p);
exception
	when others then
	nr_ultima_guia_w := '0';
end;

begin
select	count(*)
into STRICT	qt_guia_w
from	w_interf_conta_autor a
where	a.nr_seq_protocolo	= nr_seq_protocolo_p;
exception
	when others then
	qt_guia_w := 0;
end;

select	coalesce(sum(b.vl_procedimento),0)
into STRICT	vl_procedimento_w
from	conta_paciente_honorario_v b
where	b.nr_seq_protocolo		= nr_seq_protocolo_p
and	coalesce(b.ie_cancelamento::text, '') = ''
and	CASE WHEN coalesce(b.nr_seq_proc_pacote::text, '') = '' THEN b.nr_sequencia  ELSE b.nr_seq_proc_pacote END  = b.nr_sequencia
and	((ie_excluir_hon_med_w		= 'N') or (b.ie_responsavel_credito 	<> 'M') or (coalesce(b.ie_responsavel_credito::text, '') = ''))
and	((ie_excluir_hon_terc_w		= 'N') or (b.ie_responsavel_credito in ('H','RM','M')) or (coalesce(b.ie_responsavel_credito::text, '') = ''));

select	count(*)
into STRICT	qt_documento_w
from	w_interf_conta_cab
where	nr_seq_protocolo	= nr_seq_protocolo_w;

insert into w_interf_conta_trailler(
	nr_sequencia,
	cd_tipo_registro,
	nr_seq_registro,
	nr_seq_interface,
	nr_remessa,
	qt_total_conta,
	vl_total_conta,
	nr_seq_protocolo,
	cd_convenio,
	cd_cgc_hospital,
	cd_cgc_convenio,
	cd_interno,
	nr_primeira_guia,
	nr_ultima_guia,
	qt_guia)
values (	nr_sequencia_w,
	9,1,1,
	nr_seq_envio_convenio_w,
	qt_documento_w,
	vl_material_w + vl_procedimento_w,
	nr_seq_protocolo_w,
	cd_convenio_w,
	cd_cgc_hospital_w,
	cd_cgc_convenio_w,
	cd_interno_w,
	nr_primeira_guia_w,
	nr_ultima_guia_w,
	qt_guia_w);

commit;

/* Chamada especial do convenio IPE - Resumo das contas */

if (ie_agrup_item_interf_w in ('E','G')) then
	CALL atualiza_resumo_conta_ipe(nr_seq_protocolo_p,nm_usuario_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_conta ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type) FROM PUBLIC;

