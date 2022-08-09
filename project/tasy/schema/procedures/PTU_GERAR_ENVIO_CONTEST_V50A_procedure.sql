-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_envio_contest_v50a ( nr_seq_camara_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o arquivo A550 V5.0a
-------------------------------------------------------------------------------------------------------------------
OPS - Controle de Contestações
Locais de chamada direta:
[X]  Objetos do dicionário [ ]  Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/-- 552
ds_conteudo_aux_w		varchar(700);
nr_seq_questionamento_w		bigint;
ie_tipo_acordo_w		varchar(2);

-- 553
ie_tipo_w			varchar(3);
cd_motivo_w			ptu_motivo_questionamento.cd_motivo%type;
ds_conteudo_553_w		varchar(500);

-- 559
qt_552_w			bigint	:= 0;

ds_conteudo_w			varchar(700);
nr_seq_registro_w		bigint	:= 0;
nr_seq_nota_cobranca_w		bigint;
nr_seq_ptu_fatura_w		bigint;
nr_seq_lote_contest_w		bigint;
nr_seq_nota_servico_w		bigint;
vl_reconhecido_w		double precision := 0;
vl_cobrado_w			double precision := 0;
vl_contestacao_w		double precision := 0;
ie_tipo_arquivo_w		integer;
ie_motivo_ques_w		varchar(1) := 'N';
vl_tot_aco_servico_w		double precision := 0;
vl_tot_aco_taxa_w		double precision := 0;

C00 CURSOR FOR
	SELECT	'552' ||
		lpad(coalesce(nr_lote,'0'),8,'0') ||
		lpad(' ',15,' ') ||
		lpad(coalesce(cd_unimed,'0'),4,'0') ||
		lpad(coalesce(cd_usuario_plano,' '),13,' ') ||
		rpad(coalesce(upper(substr(nm_beneficiario,1,25)),' '),25,' ') ||
		lpad(coalesce(to_char(dt_atendimento,'yyyy/mm/dd') || to_char(dt_atendimento,'hh24:mi:ss') ||'-03',' '),21,' ') ||
		lpad(' ',124,' ') ||
		coalesce(to_char(ie_tipo_tabela),' ') ||
		lpad(coalesce(cd_servico,'0'),8,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobrado,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconhecido,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo,0)),'.',''),',',''),14,'0') ||
		lpad(coalesce(to_char(dt_acordo,'yyyymmdd'),' '),8,' ') ||
		lpad(coalesce(ie_tipo_acordo,' '),2,' ') ||
		lpad(substr(replace(replace(coalesce(qt_cobrada*10000,'0'),'.',''),',',''),1,8),8,'0') ||
		rpad(coalesce(elimina_acentuacao(ds_servico),' '),80,' ') ||
		lpad(coalesce(nr_seq_a500,'0'),8,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobr_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobr_filme,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_filme,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_filme,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobr_adic_serv,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_adic_serv,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_adic_serv,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobr_adic_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_adic_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_adic_co,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobr_adic_filme,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_adic_filme,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_adic_filme,0)),'.',''),',',''),14,'0') ||
		lpad(coalesce(qt_reconh,'0'),8,'0') ||
		coalesce(ie_pacote,'N') ||
		lpad(coalesce(cd_pacote,'0'),8,'0') ||
		lpad(coalesce(to_char(dt_servico,'yyyymmdd'),' '),8,' ') ||
		lpad(coalesce(hr_realiz,' '),8,' ') ||
		lpad(coalesce(qt_acordada,'0'),8,'0') ||
		lpad(coalesce(fat_mult_serv*100,'0'),3,'0') ||
		rpad(coalesce(to_char(nr_nota),' '),20,' '),
		nr_sequencia,
		lpad(coalesce(ie_tipo_acordo,' '),2,' ')
	from	ptu_questionamento
	where	nr_seq_contestacao	= nr_seq_camara_p
	and	ie_tipo_acordo not in ('11');

C01 CURSOR FOR
	SELECT	'553',
		lpad((substr(a.cd_motivo,1,4)),4,'0'),
		substr(CASE WHEN coalesce(b.ds_parecer_glosa::text, '') = '' THEN  a.ds_motivo  ELSE b.ds_parecer_glosa END ,1,500)
	from	ptu_questionamento_codigo	b,
		ptu_motivo_questionamento	a
	where	a.nr_sequencia		= b.nr_seq_mot_questionamento
	and	b.nr_seq_registro	= nr_seq_questionamento_w
	and	ie_motivo_ques_w = 'N'
	
union

	SELECT	'553',
		lpad((substr(a.cd_motivo,1,4)),4,'0'),
		substr(a.ds_motivo,1,500)
	from	ptu_motivo_questionamento a
	where	a.cd_motivo	= '99'
	and	ie_motivo_ques_w = 'S';


BEGIN
delete FROM w_ptu_envio_arq where nm_usuario = nm_usuario_p;

nr_seq_registro_w	:= nr_seq_registro_w + 1;

select	max(nr_seq_lote_contest),
	max(ie_tipo_arquivo)
into STRICT	nr_seq_lote_contest_w,
	ie_tipo_arquivo_w
from	ptu_camara_contestacao
where	nr_sequencia	= nr_seq_camara_p;

select	max(nr_seq_ptu_fatura)
into STRICT	nr_seq_ptu_fatura_w
from	pls_lote_contestacao
where	nr_sequencia = nr_seq_lote_contest_w;

vl_reconhecido_w := 0;
vl_cobrado_w	 := 0;
vl_contestacao_w := 0;

select	sum(coalesce(x.vl_reconhecido,0) + coalesce(x.vl_reconh_adic_co,0) +
	coalesce(vl_reconh_adic_filme,0) + coalesce(x.vl_reconh_adic_serv,0) +
	coalesce(x.vl_reconh_co,0) + coalesce(x.vl_reconh_filme,0)) vl_rec,
	sum(coalesce(x.vl_cobrado,0) + coalesce(x.vl_cobr_adic_co,0) +
	coalesce(x.vl_cobr_adic_filme,0) + coalesce(x.vl_cobr_adic_serv,0) +
	coalesce(x.vl_cobr_co,0) + coalesce(x.vl_cobr_filme,0)) vl_cobr
into STRICT	vl_reconhecido_w,
	vl_cobrado_w
from	ptu_questionamento x
where	x.nr_seq_contestacao = nr_seq_camara_p
and	x.ie_tipo_acordo not in ('11');

vl_contestacao_w := vl_cobrado_w - vl_reconhecido_w;

select	lpad(nr_seq_registro_w,8,'0') ||
	'551' ||
	lpad(coalesce(cd_unimed_destino,'0'),4,'0') ||
	lpad(coalesce(cd_unimed_origem,'0'),4,'0') ||
	rpad(coalesce(to_char(dt_geracao,'yyyymmdd'),' '),8,' ') ||
	lpad(coalesce(cd_unimed_credora,'0'),4,'0') ||
	lpad(' ',11,' ') ||
	lpad(coalesce(nr_fatura,'0'),11,'0') ||
	rpad(coalesce(to_char(dt_venc_fatura,'yyyymmdd'),' '),8,' ') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_fatura,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_contestacao,vl_contestacao_w)),'.',''),',',''),14,'0') ||
	lpad('0',14,'0') ||
	coalesce(to_char(ie_tipo_arquivo),' ') ||
	'10' ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_pago,0)),'.',''),',',''),14,'0') ||
	lpad(coalesce(to_char(nr_documento),'0'),11,'0') ||
	lpad(coalesce(to_char(dt_venc_doc,'yyyymmdd'),' '),8,' ') ||
	coalesce(to_char(ie_conclusao),'0') ||
	coalesce(ie_classif_cobranca_a500,'2') ||
	lpad(coalesce(nr_nota_credito_debito_a500,'0'),11,'0') ||
	lpad(coalesce(to_char(dt_vencimento_ndc_a500,'yyyymmdd'),' '),8,' ') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_ndc_a500,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_contest_ndc,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_pago_ndc,0)),'.',''),',',''),14,'0') ||
	lpad(coalesce(to_char(nr_documento2),'0'),11,'0') ||
	lpad(coalesce(to_char(dt_venc_doc2,'yyyymmdd'),' '),8,' '),
	nr_seq_lote_contest
into STRICT	ds_conteudo_w,
	nr_seq_lote_contest_w
from	ptu_camara_contestacao
where	nr_sequencia	= nr_seq_camara_p;

insert into w_ptu_envio_arq(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_conteudo)
values (nextval('w_ptu_envio_arq_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_w);

nr_seq_registro_w	:= nr_seq_registro_w + 1;

open C00;
loop
fetch C00 into
	ds_conteudo_aux_w,
	nr_seq_questionamento_w,
	ie_tipo_acordo_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	ds_conteudo_w	:= lpad(nr_seq_registro_w,8,'0') || ds_conteudo_aux_w;

	if (ie_tipo_arquivo_w = 1) and (ie_tipo_acordo_w = '11') then
		ie_motivo_ques_w := 'S';
	else
		ie_motivo_ques_w := 'N';
	end if;

	insert into w_ptu_envio_arq(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		ds_conteudo)
	values (nextval('w_ptu_envio_arq_seq'),
		clock_timestamp(),
		nm_usuario_p,
		ds_conteudo_w);

	update	ptu_questionamento
	set	nr_seq_arquivo	= nr_seq_registro_w
	where	nr_sequencia	= nr_seq_questionamento_w;

	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	qt_552_w		:= qt_552_w + 1;

	open C01;
	loop
	fetch C01 into
		ie_tipo_w,
		cd_motivo_w,
		ds_conteudo_553_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_conteudo_553_w := 	elimina_caractere_especial(Elimina_Acentuacao(ds_conteudo_553_w));
		ds_conteudo_553_w :=	replace(replace(replace(replace(replace(replace(ds_conteudo_553_w,'¿',''),chr(13),' '),chr(10),' '),chr(9),' '),'|',''),'`','');

		begin
		ds_conteudo_553_w :=	trim(both regexp_replace(ds_conteudo_553_w, '[^a-zA-Z0-9 !@#$%&*()-+={}<>:?,.;/\_'']', ''));
		exception
		when others then
			null;
		end;

		ds_conteudo_w :=	lpad(nr_seq_registro_w, 8, '0') ||
					ie_tipo_w ||
					cd_motivo_w ||
					rpad(trim(both ds_conteudo_553_w),500,' ');

		insert into w_ptu_envio_arq(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			ds_conteudo)
		values (nextval('w_ptu_envio_arq_seq'),
			clock_timestamp(),
			nm_usuario_p,
			ds_conteudo_w);

		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		end;
	end loop;
	close C01;
	end;
end loop;
close C00;

vl_reconhecido_w := 0;
vl_cobrado_w	 := 0;

select	sum(coalesce(vl_reconhecido,0) + coalesce(vl_reconh_adic_co,0) +
	coalesce(vl_reconh_adic_filme,0) + coalesce(vl_reconh_adic_serv,0) +
	coalesce(vl_reconh_co,0) + coalesce(vl_reconh_filme,0)) vl_reconhecido_w,
	sum(coalesce(vl_cobrado,0) + coalesce(vl_cobr_adic_co,0) +
	coalesce(vl_cobr_adic_filme,0) + coalesce(vl_cobr_adic_serv,0) +
	coalesce(vl_cobr_co,0) + coalesce(vl_cobr_filme,0)) vl_cobrado_w,
	sum(coalesce(vl_acordo,0) + coalesce(vl_acordo_co,0) +
	coalesce(vl_acordo_filme,0)) vl_tot_aco_servico_w,
	sum(coalesce(vl_acordo_adic_serv,0) + coalesce(vl_acordo_adic_co,0) +
	coalesce(vl_acordo_adic_filme,0)) vl_tot_aco_taxa_w
into STRICT	vl_reconhecido_w,
	vl_cobrado_w,
	vl_tot_aco_servico_w,
	vl_tot_aco_taxa_w
from	ptu_questionamento x
where	x.nr_seq_contestacao = nr_seq_camara_p
and	x.ie_tipo_acordo not in ('11');

if (ie_tipo_arquivo_w not in (5,6)) then
	vl_tot_aco_servico_w := 0;
	vl_tot_aco_taxa_w := 0;
end if;

select	lpad(nr_seq_registro_w,8,'0') ||
	'559' ||
	lpad(qt_552_w,5,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobrado_w,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconhecido_w,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_tot_aco_servico_w,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_tot_aco_taxa_w,0)),'.',''),',',''),14,'0')
into STRICT	ds_conteudo_w
from	ptu_camara_contestacao
where	nr_sequencia	= nr_seq_camara_p;

insert into w_ptu_envio_arq(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_conteudo)
values (nextval('w_ptu_envio_arq_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_envio_contest_v50a ( nr_seq_camara_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
