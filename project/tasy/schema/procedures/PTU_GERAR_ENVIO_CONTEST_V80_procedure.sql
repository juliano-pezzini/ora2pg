-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_envio_contest_v80 ( nr_seq_camara_p ptu_camara_contestacao.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o arquivo A550 V8.0
-------------------------------------------------------------------------------------------------------------------
OPS - Controle de Contestações
Locais de chamada direta:
[X]  Objetos do dicionário [ ]  Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ds_arquivo_w			text;
ds_hash_w			ptu_camara_contestacao.ds_hash%type;

-- Conteudo
ds_conteudo_w			varchar(700);
ds_conteudo_aux_w		varchar(700);
ds_conteudo_553_w		varchar(500);
ie_registro_w			varchar(3);
nr_seq_questionamento_w		ptu_questionamento.nr_sequencia%type; -- 552
cd_motivo_w			ptu_motivo_questionamento.cd_motivo%type; -- 553
nr_seq_quest_rrs_w		ptu_questionamento_rrs.nr_sequencia%type; -- 557
nr_seq_registro_w		integer	:= 1;
vl_reconhecido_w		double precision 	:= 0;
vl_cobrado_w			double precision 	:= 0;
vl_contestacao_w		double precision 	:= 0;

-- 559
qt_552_w			integer	:= 0;
qt_557_w			integer	:= 0;
qt_558_w			integer	:= 0;

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
		lpad(substr(replace(replace(coalesce(qt_reconh*10000,'0'),'.',''),',',''),1,8),8,'0') ||
		coalesce(ie_pacote,'N') ||
		lpad(coalesce(cd_pacote,'0'),8,'0') ||
		lpad(coalesce(to_char(dt_servico,'yyyymmdd'),' '),8,' ') ||
		lpad(coalesce(hr_realiz,' '),8,' ') ||
		lpad(coalesce(qt_acordada,'0'),8,'0') ||
		lpad(coalesce(fat_mult_serv*100,'0'),3,'0') ||
		rpad(coalesce(to_char(nr_nota),' '),20,' '),
		nr_sequencia
	from	ptu_questionamento
	where	nr_seq_contestacao	= nr_seq_camara_p
	and	ie_tipo_acordo not in ('11');

C01 CURSOR FOR
	SELECT	lpad((substr(a.cd_motivo,1,4)),4,'0'),
		ptu_somente_caracter_permitido(substr(CASE WHEN coalesce(b.ds_parecer_glosa::text, '') = '' THEN  a.ds_motivo  ELSE b.ds_parecer_glosa END ,1,500), 'ANS')
	from	ptu_questionamento_codigo	b,
		ptu_motivo_questionamento	a
	where	a.nr_sequencia		= b.nr_seq_mot_questionamento
	and	b.nr_seq_registro	= nr_seq_questionamento_w
	
union all

	SELECT	lpad((substr(a.cd_motivo,1,4)),4,'0'),
		ptu_somente_caracter_permitido(substr(CASE WHEN coalesce(b.ds_parecer_glosa::text, '') = '' THEN  a.ds_motivo  ELSE b.ds_parecer_glosa END ,1,500), 'ANS')
	from	ptu_questionamento_codigo	b,
		ptu_motivo_questionamento	a
	where	a.nr_sequencia		= b.nr_seq_mot_questionamento
	and	b.nr_seq_registro_rrs	= nr_seq_quest_rrs_w;

C13 CURSOR FOR
	SELECT	'557' ||
		lpad(coalesce(nr_lote,'0'),8,'0') ||
		rpad(coalesce(to_char(nr_nota),' '),20,' ') ||
		lpad(coalesce(cd_unimed,'0'),4,'0') ||
		lpad(coalesce(id_benef,' '),13,' ') ||
		rpad(coalesce(upper(substr(nm_beneficiario,1,25)),' '),25,' ') ||
		lpad(coalesce(to_char(dt_reembolso,'yyyymmdd'),' '),8,' ') ||
		lpad(coalesce(nr_cnpj_cpf,' '),14,' ') ||
		rpad(coalesce(substr(nm_prestador,1,40),' '),40,' '),
		nr_sequencia
	from	ptu_questionamento_rrs
	where	nr_seq_contestacao	= nr_seq_camara_p;

C14 CURSOR FOR
	SELECT	'558' ||
		lpad(coalesce(nr_lote,'0'),8,'0') ||
		rpad(coalesce(to_char(nr_nota),' '),20,' ') ||
		lpad(coalesce(nr_seq_a500,'0'),8,'0') ||
		lpad(coalesce(to_char(dt_servico,'yyyymmdd'),' '),8,' ') ||
		coalesce(tp_particip,' ') ||
		coalesce(tp_tabela,' ') ||
		lpad(coalesce(cd_servico,'0'),8,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_serv,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_dif_vl_inter,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconh_serv,0)),'.',''),',',''),14,'0') ||
		lpad(replace(replace(campo_mascara_virgula(coalesce(vl_acordo_serv,0)),'.',''),',',''),14,'0') ||
		lpad(coalesce(to_char(dt_acordo,'yyyymmdd'),' '),8,' ') ||
		lpad(coalesce(tp_acordo,' '),2,' ') ||
		lpad(substr(replace(replace(coalesce(qt_cobrada*10000,'0'),'.',''),',',''),1,8),8,'0') ||
		lpad(substr(replace(replace(coalesce(qt_reconh*10000,'0'),'.',''),',',''),1,8),8,'0') ||
		lpad(substr(replace(replace(coalesce(qt_acordada*10000,'0'),'.',''),',',''),1,8),8,'0') ||
		rpad(coalesce(substr(nm_profissional,1,40),' '),40,' ') ||
		rpad(coalesce(sg_cons_prof,' '),12,' ') ||
		rpad(coalesce(nr_cons_prof,' '),15,' ') ||
		rpad(coalesce(sg_uf_cons_prof,' '),2,' ') ||
		lpad(coalesce(nr_autoriz,'0'),10,'0')
	from	ptu_quest_serv_rrs
	where	nr_seq_quest_rrs	= nr_seq_quest_rrs_w
	and	tp_acordo not in ('11');


BEGIN
delete	FROM w_ptu_envio_arq
where	nm_usuario = nm_usuario_p;

select	CASE WHEN count(1)=0 THEN '557'  ELSE '552' END
into STRICT	ie_registro_w
from	ptu_questionamento
where	nr_seq_contestacao = nr_seq_camara_p;

select	sum(coalesce(x.vl_reconhecido,0) + coalesce(x.vl_reconh_adic_co,0) +
	coalesce(x.vl_reconh_adic_filme,0) + coalesce(x.vl_reconh_adic_serv,0) +
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
	lpad(' ',11,' ') ||
	rpad(coalesce(to_char(dt_venc_fatura,'yyyymmdd'),' '),8,' ') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_fatura,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_contestacao,vl_contestacao_w)),'.',''),',',''),14,'0') ||
	lpad(' ',14,' ') ||
	coalesce(to_char(ie_tipo_arquivo),' ') ||
	'14' ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_pago,0)),'.',''),',',''),14,'0') ||
	lpad(coalesce(to_char(nr_documento),'0'),11,'0') ||
	lpad(coalesce(to_char(dt_venc_doc,'yyyymmdd'),' '),8,' ') ||
	coalesce(to_char(ie_conclusao),'0') ||
	coalesce(ie_classif_cobranca_a500,'2') ||
	lpad('0',11,'0') ||
	lpad(coalesce(to_char(dt_vencimento_ndc_a500,'yyyymmdd'),' '),8,' ') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_ndc_a500,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_contest_ndc,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_total_pago_ndc,0)),'.',''),',',''),14,'0') ||
	lpad(coalesce(to_char(nr_documento2),'0'),11,'0') ||
	lpad(coalesce(to_char(dt_venc_doc2,'yyyymmdd'),' '),8,' ') ||
	rpad(coalesce(nr_fatura,' '),20,' ') ||
	rpad(coalesce(nr_nota_credito_debito_a500,' '),20,' ') ||
	'0'
into STRICT	ds_conteudo_w
from	ptu_camara_contestacao
where	nr_sequencia	= nr_seq_camara_p;

ds_arquivo_w := ds_arquivo_w || ds_conteudo_w;

insert into w_ptu_envio_arq(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_conteudo)
values (nextval('w_ptu_envio_arq_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_w);

nr_seq_registro_w	:= nr_seq_registro_w + 1;

-- REGISTRO 552
if (ie_registro_w = '552') then
	open C00;
	loop
	fetch C00 into
		ds_conteudo_aux_w,
		nr_seq_questionamento_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
		begin
		ds_conteudo_w	:= lpad(nr_seq_registro_w,8,'0') || ds_conteudo_aux_w;
		ds_arquivo_w	:= ds_arquivo_w || ds_conteudo_w;

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
			cd_motivo_w,
			ds_conteudo_553_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			ds_conteudo_553_w :=	replace(replace(replace(ptu_somente_caracter_permitido(ds_conteudo_553_w,'ANS'),chr(13),' '),chr(10),' '),chr(9),' ');

			ds_conteudo_w :=	lpad(nr_seq_registro_w, 8, '0') ||
						'553' ||
						cd_motivo_w ||
						rpad(trim(both ds_conteudo_553_w),500,' ');
			ds_arquivo_w :=		ds_arquivo_w || ds_conteudo_w;

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

-- REGISTRO 557
elsif (ie_registro_w = '557') then
	open C13;
	loop
	fetch C13 into
		ds_conteudo_aux_w,
		nr_seq_quest_rrs_w;
	EXIT WHEN NOT FOUND; /* apply on C13 */
		begin

		-- INSERE PRIMEIRO O REGISTRO 553
		open C01;
		loop
		fetch C01 into
			cd_motivo_w,
			ds_conteudo_553_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			ds_conteudo_553_w :=	replace(replace(replace(ptu_somente_caracter_permitido(ds_conteudo_553_w,'ANS'),chr(13),' '),chr(10),' '),chr(9),' ');

			ds_conteudo_w :=	lpad(nr_seq_registro_w, 8, '0') ||
						'553' ||
						cd_motivo_w ||
						rpad(trim(both ds_conteudo_553_w),500,' ');
			ds_arquivo_w :=		ds_arquivo_w || ds_conteudo_w;

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

		ds_conteudo_w	:= lpad(nr_seq_registro_w,8,'0') || ds_conteudo_aux_w;
		ds_arquivo_w	:= ds_arquivo_w || ds_conteudo_w;

		-- REGISTRO 557
		insert into w_ptu_envio_arq(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			ds_conteudo)
		values (nextval('w_ptu_envio_arq_seq'),
			clock_timestamp(),
			nm_usuario_p,
			ds_conteudo_w);

		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		qt_557_w		:= qt_557_w + 1;

		-- REGISTRO 558
		open C14;
		loop
		fetch C14 into
			ds_conteudo_aux_w;
		EXIT WHEN NOT FOUND; /* apply on C14 */
			begin

			ds_conteudo_w	:= lpad(nr_seq_registro_w,8,'0') || ds_conteudo_aux_w;
			ds_arquivo_w	:= ds_arquivo_w || ds_conteudo_w;

			-- REGISTRO 558
			insert into w_ptu_envio_arq(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				ds_conteudo)
			values (nextval('w_ptu_envio_arq_seq'),
				clock_timestamp(),
				nm_usuario_p,
				ds_conteudo_w);

			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			qt_558_w		:= qt_558_w + 1;

			end;
		end loop;
		close C14;

		end;
	end loop;
	close C13;
end if;

select	lpad(nr_seq_registro_w,8,'0') ||
	'559' ||
	lpad(qt_552_w,5,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_cobrado_w,0)),'.',''),',',''),14,'0') ||
	lpad(replace(replace(campo_mascara_virgula(coalesce(vl_reconhecido_w,0)),'.',''),',',''),14,'0') ||
	lpad('0',14,'0') ||
	lpad('0',14,'0') ||
	lpad(qt_557_w,5,'0') ||
	lpad(qt_558_w,5,'0')
into STRICT	ds_conteudo_w
from	ptu_camara_contestacao
where	nr_sequencia	= nr_seq_camara_p;

ds_arquivo_w :=	ds_arquivo_w || ds_conteudo_w;

insert into w_ptu_envio_arq(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_conteudo)
values (nextval('w_ptu_envio_arq_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_w);

-- R998 ¿ Hash (OBRIGATÓRIO)
nr_seq_registro_w	:=	nr_seq_registro_w + 1;
ds_arquivo_w := pls_hash_ptu_pck.obter_hash_txt(ds_arquivo_w); -- Gerar HASH
ds_conteudo_w		:=	lpad(nr_seq_registro_w,8,'0') || '998' || ds_hash_w;

insert into w_ptu_envio_arq(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_conteudo)
values (nextval('w_ptu_envio_arq_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_w);

update	ptu_camara_contestacao
set	ds_hash		= ds_hash_w
where	nr_sequencia	= nr_seq_camara_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_envio_contest_v80 ( nr_seq_camara_p ptu_camara_contestacao.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

