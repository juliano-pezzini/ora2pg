-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_i200_ecd_aux ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
finalidade: gerar as informações dos registros de:
	"lançamento contábil" - i200
	"partidas do lançamento" - i250
-------------------------------------------------------------------------------------------------------------------
locais de chamada direta:
[ x ]  objetos do dicionário [  ] tasy (delphi/java) [  ] portal [  ]  relatórios [ ] outros:
 ------------------------------------------------------------------------------------------------------------------
pontos de atenção:
	ie_consolida_empresa, pois irá gerar um registro para cada estabelecimento
	da empresa se estiver como "sim".

	ie_apres_conta_ctb - campo "apresentação conta" da pasta "regra"
		cd - código
		cl - classificação
		cp - classificação sem os pontos

	ie_forma_num_lcto - campo "identif i200" da pasta "regra"
		ag - agrupador sequencial
		nr - sequência do movimento
-------------------------------------------------------------------------------------------------------------------
referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_credito_total_w		ctb_movimento.vl_movimento%type;
vl_debito_total_w		ctb_movimento.vl_movimento%type;
ie_consolida_empresa_w		ctb_regra_sped.ie_consolida_empresa%type;
nr_sequencia_w                  ctb_movimento.nr_sequencia%type;
dt_movimento_lanc_w    	        ctb_movimento.dt_movimento%type;
vl_movimento_lanc_w   	        ctb_movimento.vl_movimento%type;
ie_debito_credito_w 	        movimento_contabil.ie_debito_credito%type;
nr_lancamento_w      		movimento_contabil.nr_lancamento%type;
cd_conta_contabil_lanc_w	movimento_contabil.cd_conta_contabil%type;
nr_seq_doc_compl_w    		movimento_contabil_doc.nr_seq_doc_compl%type;
nr_seq_info_w       	        movimento_contabil_doc.nr_seq_info%type;
nr_documento_w       		movimento_contabil_doc.nr_documento%type;
cd_historico_w                  ctb_movimento.cd_historico%type;
cd_centro_custo_w               movimento_contabil.cd_centro_custo%type;
ds_compl_historico_w            varchar(255);
ds_informacao_w                 varchar(255);
sep_w				varchar(1)	:= '|';
ie_tipo_lancamento_w		varchar(2);
tp_registro_w			varchar(15);
ie_forma_num_lcto_w		varchar(15);
ie_apres_conta_ctb_w		varchar(15);
cd_conta_contabil_w		varchar(40);
ds_historico_w			varchar(255);
ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
ds_linha_w			varchar(8000);
dt_atualizacao_w		timestamp;
dt_movimento_w			timestamp;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
qt_commit_w			bigint	:= 0;
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint	:= nr_sequencia_p;
vl_movimento_w			double precision;
nr_agrup_sequencial_ini_w	bigint;
nr_agrup_sequencial_fim_w	bigint;
nr_agrup_sequencial_w		bigint;
nr_linha_i200_w			bigint;
nr_vetor_i200_w			bigint;
nr_seq_registro_i200_w		bigint;
idx				bigint;
testes_w			bigint;
nr_agrup_sequencial_ant		bigint;



c_lancamento CURSOR FOR
	SELECT	a.nr_agrup_sequencial,
		a.dt_movimento,
		a.nr_lote_contabil,
		a.ie_encerramento,
		coalesce(sum(a.vl_movimento),0)	vl_movimento
	from	ctb_movimento_v2	a,
		ctb_mes_ref		b,
		lote_contabil		d
	where	b.nr_sequencia		= a.nr_seq_mes_ref
	and	b.nr_sequencia		= d.nr_seq_mes_ref
	and	d.nr_lote_contabil	= a.nr_lote_contabil
	and	b.cd_empresa		= cd_empresa_p
	and	a.cd_estabelecimento	= coalesce(cd_estabelecimento_p, a.cd_estabelecimento)
	and	b.dt_referencia between dt_inicio_w and dt_fim_w
	and	ie_consolida_empresa_w	= 'N'
	and 	(a.nr_agrup_sequencial IS NOT NULL AND a.nr_agrup_sequencial::text <> '')
	group by a.nr_agrup_sequencial,
		a.dt_movimento,
		a.nr_lote_contabil,
		a.ie_encerramento
	
union all

	SELECT	a.nr_agrup_sequencial,
		a.dt_movimento,
		a.nr_lote_contabil,
		a.ie_encerramento,
		coalesce(sum(a.vl_movimento),0)	vl_movimento
	from	ctb_movimento_v2	a,
		ctb_mes_ref		b,
		lote_contabil		d,
		estabelecimento 	e
	where	b.nr_sequencia		= a.nr_seq_mes_ref
	and	b.nr_sequencia		= d.nr_seq_mes_ref
	and	d.nr_lote_contabil	= a.nr_lote_contabil
	and	b.cd_empresa		= cd_empresa_p
	and	a.cd_estabelecimento	= e.cd_estabelecimento
	and	b.dt_referencia between dt_inicio_w and dt_fim_w
	and	ie_consolida_empresa_w	= 'S'
	and 	(a.nr_agrup_sequencial IS NOT NULL AND a.nr_agrup_sequencial::text <> '')
	group by a.nr_agrup_sequencial,
		a.dt_movimento,
		a.nr_lote_contabil,
		a.ie_encerramento
	order by 1, 2;

vet010	c_lancamento%rowtype;

c_partidas_lancamento CURSOR FOR
SELECT  a.nr_sequencia,
	a.dt_movimento,
	a.vl_movimento,
        b.ie_debito_credito,
    	b.nr_lancamento,
	b.cd_conta_contabil,
        c.nr_seq_doc_compl,
        c.nr_seq_info,
        c.nr_documento,
	a.ds_compl_historico,
	substr(obter_informacao_contabil(c.nr_seq_info),1,255) ds_informacao,
	a.cd_historico,
	b.cd_centro_custo
from  	ctb_movimento a,
	movimento_contabil b,
	movimento_contabil_doc c
where 	b.nr_seq_ctb_movto	= a.nr_sequencia
and	b.nr_lote_contabil	= a.nr_lote_contabil
and	b.nr_lote_contabil	= c.nr_lote_contabil
and   	c.nr_seq_movimento	= b.nr_sequencia
and     a.nr_agrup_sequencial =	nr_agrup_sequencial_w;


nr_vetor_w			bigint	:= 0;
type registro is table of ctb_sped_registro%rowtype index by integer;
ctb_sped_registro_w		registro;


BEGIN
select	coalesce(max(a.ie_apres_conta_ctb), 'CD'),
	coalesce(max(a.ie_forma_num_lcto), 'NR'),
	coalesce(max(a.ie_consolida_empresa), 'N')
into STRICT	ie_apres_conta_ctb_w,
	ie_forma_num_lcto_w,
	ie_consolida_empresa_w
from	ctb_regra_sped a,
	ctb_sped_controle b
where	a.nr_sequencia	= b.nr_seq_regra_sped
and	b.nr_sequencia	= nr_seq_controle_p;

dt_inicio_w	:= 	trunc(dt_inicio_p);
dt_fim_w	:=	fim_mes(dt_fim_p);


begin
nr_agrup_sequencial_ant := 0;
ie_tipo_lancamento_w	:= null;
open c_lancamento;
loop
fetch c_lancamento into
	vet010;
EXIT WHEN NOT FOUND; /* apply on c_lancamento */
	begin
	nr_seq_registro_w	:= nr_seq_registro_w + 1;

	ie_tipo_lancamento_w	:= 'N';
	nr_seq_registro_i200_w	:= nr_seq_registro_w;
	dt_movimento_w		:= vet010.dt_movimento;
	vl_movimento_w		:= vet010.vl_movimento;
	nr_agrup_sequencial_w	:= vet010.nr_agrup_sequencial;
	/* registro i 200*/

	tp_registro_w		:= 'I200';
	ds_linha_w		:= substr(	sep_w || tp_registro_w					||
						sep_w || nr_agrup_sequencial_w				||
						sep_w || to_char(dt_movimento_w,'ddmmyyyy')		||
						sep_w || sped_obter_campo_valor(vl_movimento_w)		||
						sep_w || ie_tipo_lancamento_w 				||
						sep_w,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);

	ctb_sped_registro_w[nr_vetor_i200_w].nr_sequencia		:= nr_seq_registro_i200_w;
	ctb_sped_registro_w[nr_vetor_i200_w].ds_arquivo			:= ds_arquivo_w;
	ctb_sped_registro_w[nr_vetor_i200_w].dt_atualizacao		:= dt_atualizacao_w;
	ctb_sped_registro_w[nr_vetor_i200_w].nm_usuario			:= nm_usuario_p;
	ctb_sped_registro_w[nr_vetor_i200_w].dt_atualizacao_nrec	:= dt_atualizacao_w;
	ctb_sped_registro_w[nr_vetor_i200_w].nm_usuario_nrec		:= nm_usuario_p;
	ctb_sped_registro_w[nr_vetor_i200_w].nr_seq_controle_sped	:= nr_seq_controle_p;
	ctb_sped_registro_w[nr_vetor_i200_w].ds_arquivo_compl		:= ds_compl_arquivo_w;
	ctb_sped_registro_w[nr_vetor_i200_w].cd_registro		:= tp_registro_w;
	ctb_sped_registro_w[nr_vetor_i200_w].nr_linha			:= nr_linha_i200_w;
	ctb_sped_registro_w[nr_vetor_i200_w].nr_doc_origem		:= nr_agrup_sequencial_w;


	nr_vetor_i200_w		:= 0;
	nr_seq_registro_i200_w	:= 0;
	nr_linha_i200_w		:= 0;

	if (nr_vetor_w >= 1000) then
		begin

		forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
			insert into ctb_sped_registro values ctb_sped_registro_w(m);

		nr_vetor_w		:= 0;
		ctb_sped_registro_w.delete;

		commit;

		end;
	end if;

	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w 	+ 1;
	nr_vetor_w		:= nr_vetor_w 	+ 1;
	nr_seq_registro_i200_w	:= nr_seq_registro_w;
	nr_linha_i200_w		:= nr_linha_w;
	nr_vetor_i200_w		:= nr_vetor_w;

	dt_atualizacao_w	:= clock_timestamp();


	/*
	Chamada do cursor

	*/
	open c_partidas_lancamento;
	loop
        fetch c_partidas_lancamento into
		nr_sequencia_w,
		dt_movimento_lanc_w,
		vl_movimento_lanc_w,
		ie_debito_credito_w,
		nr_lancamento_w,
		cd_conta_contabil_lanc_w,
		nr_seq_doc_compl_w,
		nr_seq_info_w,
		nr_documento_w,
		ds_compl_historico_w,
		ds_informacao_w,
		cd_historico_w,
		cd_centro_custo_w;
	EXIT WHEN NOT FOUND; /* apply on c_partidas_lancamento */
	begin

			tp_registro_w		:= 'I250';
			ds_historico_w		:= substr(ds_compl_historico_w || ' ' || ds_informacao_w || ' ' || nr_documento_w,1, 255);
			ds_historico_w		:= substr(replace(replace(replace(ds_historico_w,chr(13),' '),chr(10),' '),'|',''),1,255);
			ds_historico_w		:= substr(replace(ds_historico_w,chr(9),''),1,255);
			cd_conta_contabil_w	:= cd_conta_contabil_lanc_w;

			if (ie_apres_conta_ctb_w = 'CL') then
				cd_conta_contabil_w	:= cd_conta_contabil_lanc_w;
			elsif (ie_apres_conta_ctb_w = 'CP') then
				cd_conta_contabil_w	:= substr(replace(cd_conta_contabil_lanc_w,'.',''),1,40);
			end if;

			ds_linha_w	:= substr(	sep_w || tp_registro_w					||
							sep_w || cd_conta_contabil_w 				||
							sep_w || cd_centro_custo_w 				||
							sep_w || sped_obter_campo_valor(vl_movimento_lanc_w)	||
							sep_w || ie_debito_credito_w	 			||
							sep_w || nr_documento_w 				||
							sep_w || cd_historico_w 				||
							sep_w || ds_historico_w 				||
							sep_w || ''						||
							sep_w, 1,8000);

			ds_arquivo_w		:= substr(ds_linha_w,1,4000);
			ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			nr_linha_w		:= nr_linha_w + 1;
			qt_commit_w		:= qt_commit_w + 1;
			nr_vetor_w		:= nr_vetor_w + 1;

			ctb_sped_registro_w[nr_vetor_w].nr_sequencia		:= nr_seq_registro_w;
			ctb_sped_registro_w[nr_vetor_w].ds_arquivo		:= ds_arquivo_w;
			ctb_sped_registro_w[nr_vetor_w].dt_atualizacao		:= clock_timestamp();
			ctb_sped_registro_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
			ctb_sped_registro_w[nr_vetor_w].dt_atualizacao_nrec	:= clock_timestamp();
			ctb_sped_registro_w[nr_vetor_w].nm_usuario_nrec		:= nm_usuario_p;
			ctb_sped_registro_w[nr_vetor_w].nr_seq_controle_sped	:= nr_seq_controle_p;
			ctb_sped_registro_w[nr_vetor_w].ds_arquivo_compl	:= ds_compl_arquivo_w;
			ctb_sped_registro_w[nr_vetor_w].cd_registro		:= tp_registro_w;
			ctb_sped_registro_w[nr_vetor_w].nr_linha		:= nr_linha_w;
			ctb_sped_registro_w[nr_vetor_w].nr_doc_origem		:= nr_agrup_sequencial_w;
	/*

	Encerramento do cursor de partidas

	*/
	end;
        end loop;
	close c_partidas_lancamento;

	end;
end loop;
close c_lancamento;
end;



if (ctb_sped_registro_w.count > 0) then
	forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
		insert into ctb_sped_registro values ctb_sped_registro_w(m);
end if;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_i200_ecd_aux ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
