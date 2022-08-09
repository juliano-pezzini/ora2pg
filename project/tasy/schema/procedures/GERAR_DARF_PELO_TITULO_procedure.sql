-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_darf_pelo_titulo ( nr_titulo_p bigint, cd_tributo_p bigint, dt_imposto_p timestamp, cd_estabelecimento_p bigint ) AS $body$
DECLARE

 
cd_darf_imposto_w			varchar(10);
dt_darf_w				timestamp;
dt_imposto_w			timestamp;
dt_inicio_vigencia_w		timestamp;
ie_periodicidade_w			varchar(10);
nr_seq_darf_w			bigint;
nr_seq_regra_w			bigint;
nr_titulo_orig_w		bigint;
qt_registros_w			bigint;
vl_total_darf_w			double precision;
dia_apuracao_w			varchar(2);
mes_apuracao_w			varchar(2);
ano_apuracao_w			varchar(4);


BEGIN 
 
select	coalesce(max(cd_darf),'0') 
into STRICT	cd_darf_imposto_w 
from	titulo_pagar_imposto 
where	substr(Obter_Titulo_Imposto(nr_sequencia),1,10) = nr_titulo_p 
and		cd_tributo = cd_tributo_p;
 
if (cd_darf_imposto_w = '0') then 
 
	select	max(nr_titulo) 
	into STRICT	nr_titulo_orig_w 
	from	titulo_pagar_imposto 
	where	substr(Obter_Titulo_Imposto(nr_sequencia),1,10) = nr_titulo_p 
	and	cd_tributo = cd_tributo_p;
 
		 
	--Buscar o código DARF do tributo 
	select	max(coalesce(cd_darf, substr(obter_codigo_darf(cd_tributo, (obter_descricao_padrao('TITULO_PAGAR','CD_ESTABELECIMENTO',nr_titulo))::numeric , 
			obter_descricao_padrao('TITULO_PAGAR','CD_CGC',nr_titulo), obter_descricao_padrao('TITULO_PAGAR','CD_PESSOA_FISICA',nr_titulo)),1,10))) 
	into STRICT	cd_darf_imposto_w 
	from	titulo_pagar_imposto 
	where	nr_titulo = nr_titulo_orig_w 
	and	cd_tributo = cd_tributo_p;
	 
end if;
 
if (coalesce(cd_darf_imposto_w,0) = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(361305);		
end if;
 
-- Verificar se o título já está inserido em alguma DARF 
select	coalesce(max(nr_seq_darf),0) 
into STRICT	nr_seq_darf_w 
from	darf_titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
if (nr_seq_darf_w > 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(249221,'NR_SEQ_DARF_P=' || nr_seq_darf_w);
end if;	
	 
select	fim_mes(dt_emissao) 
into STRICT	dt_imposto_w 
from	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
-- Buscar a periodicidade do tributo 
select	coalesce(max(ie_periodicidade),'M') 
into STRICT	ie_periodicidade_w 
from	tributo_dctf 
where	cd_tributo = cd_tributo_p 
and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia,clock_timestamp());
 
 
-- Verificar se existe alguma DARF gerada para este código de retenção. 
if (ie_periodicidade_w = 'M') then -- Caso a periodicidade seja mensal a data do imposto do título tem que ser igual a da DARF 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	darf 
	where	cd_darf = cd_darf_imposto_w 
	and	trunc(dt_apuracao,'dd') = trunc(dt_imposto_w,'dd') 
	and	cd_estabelecimento = cd_estabelecimento_p;
	 
	dt_darf_w := dt_imposto_w;
 
elsif (ie_periodicidade_w = 'Q') then 
 
	select	dt_emissao 
	into STRICT	dt_imposto_w 
	from	titulo_pagar 
	where	nr_titulo = nr_titulo_p;
	 
	if ((to_char(dt_imposto_w,'dd'))::numeric  <= 15) then 
		 
		dia_apuracao_w := '15';
		mes_apuracao_w := to_char(dt_imposto_w, 'mm');
		ano_apuracao_w := to_char(dt_imposto_w, 'yyyy');
	else 
		if ((to_char(dt_imposto_w, 'mm') = '04') or (to_char(dt_imposto_w, 'mm') = '06') or (to_char(dt_imposto_w, 'mm') = '09') or (to_char(dt_imposto_w, 'mm') = '11')) then 
			dia_apuracao_w := '30';
			mes_apuracao_w := to_char(dt_imposto_w, 'mm');
			ano_apuracao_w := to_char(dt_imposto_w, 'yyyy');
		elsif (to_char(dt_imposto_w, 'mm') = '02') then 
			dia_apuracao_w := '28';
			mes_apuracao_w := to_char(dt_imposto_w, 'mm');
			ano_apuracao_w := to_char(dt_imposto_w, 'yyyy');			
		else	 
			dia_apuracao_w := '31';
			mes_apuracao_w := to_char(dt_imposto_w, 'mm');
			ano_apuracao_w := to_char(dt_imposto_w, 'yyyy');		
		end if;
	end if;	
 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	darf 
	where	cd_darf = cd_darf_imposto_w 
	and	dt_apuracao = dt_darf_w 
	and	cd_estabelecimento = cd_estabelecimento_p;
	 
	dt_darf_w := to_date(dia_apuracao_w || '/' || mes_apuracao_w || '/' || ano_apuracao_w,'dd/mm/yyyy');
	 
elsif (ie_periodicidade_w = 'T') then 
	 
	mes_apuracao_w := to_char(dt_imposto_w, 'mm');
	ano_apuracao_w := to_char(dt_imposto_w, 'yyyy');	
	 
	if ((to_char(dt_imposto_w,'mm') = '01') or (to_char(dt_imposto_w,'mm') = '02') or (to_char(dt_imposto_w,'mm') = '03')) then 
 
		-- Se o mês do tributo for janeiro, fevereiro ou março, a DARF terá que ser de março 
		dt_darf_w := to_date('31/' || mes_apuracao_w || '/' || ano_apuracao_w,'dd/mm/yyyy');
		 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	darf 
		where	cd_darf = cd_darf_imposto_w 
		and	dt_apuracao = dt_darf_w 
		and	cd_estabelecimento = cd_estabelecimento_p;
		 
		dia_apuracao_w := '31';
 
	elsif ((to_char(dt_imposto_w,'mm') = '04') or (to_char(dt_imposto_w,'mm') = '05') or (to_char(dt_imposto_w,'mm') = '06')) then 
		 
		-- Se o mês do tributo for abril, maio ou junho, a DARF terá que ser de junho 
		dt_darf_w := to_date('30/' || mes_apuracao_w || '/' || ano_apuracao_w,'dd/mm/yyyy');
		 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	darf 
		where	cd_darf = cd_darf_imposto_w 
		and	dt_apuracao = dt_darf_w 
		and	cd_estabelecimento = cd_estabelecimento_p;
		 
		dia_apuracao_w := '30';
		 
	elsif ((to_char(dt_imposto_w,'mm') = '07') or (to_char(dt_imposto_w,'mm') = '08') or (to_char(dt_imposto_w,'mm') = '09')) then 
		 
		-- Se o mês do tributo for julho, agosto ou setembro, a DARF terá que ser de setembro 
		dt_darf_w := to_date('30/' || mes_apuracao_w || '/' || ano_apuracao_w,'dd/mm/yyyy');
		 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	darf 
		where	cd_darf = cd_darf_imposto_w 
		and	dt_apuracao = dt_darf_w 
		and	cd_estabelecimento = cd_estabelecimento_p;
		 
		dia_apuracao_w := '30';
 
	elsif ((to_char(dt_imposto_w,'mm') = '10') or (to_char(dt_imposto_w,'mm') = '11') or (to_char(dt_imposto_w,'mm') = '12')) then 
		 
		-- Se o mês do tributo for outubro, novembro ou dezembro, a DARF terá que ser de dezembro 
		dt_darf_w := to_date('31/' || mes_apuracao_w || '/' || ano_apuracao_w,'dd/mm/yyyy');
		 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	darf 
		where	cd_darf = cd_darf_imposto_w 
		and		dt_apuracao = dt_darf_w 
		and		cd_estabelecimento = cd_estabelecimento_p;
		 
		dia_apuracao_w := '31';
		 
	end if;
else 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(361233);
end if;
 
-- Se existir uma DARF (qt_registros_w > 0) então deverá inserir o título nesta DARF 
if (qt_registros_w > 0) then 
	 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_darf_w 
	from	darf 
	where	cd_darf = cd_darf_imposto_w 
	and		trunc(dt_apuracao,'dd') = trunc(dt_darf_w,'dd') 
	and		cd_estabelecimento = cd_estabelecimento_p;
 
	insert into darf_titulo_pagar( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_darf, 
					nr_titulo) 
			values (	 
					nextval('darf_titulo_pagar_seq'), 
					clock_timestamp(), 
					'Tasy', 
					clock_timestamp(), 
					'Tasy', 
					nr_seq_darf_w, 
					nr_titulo_p		 
					);
	 
-- Senão, criar uma DARF nova e insere o título 
else 
 
	select	nextval('darf_seq') 
	into STRICT	nr_seq_darf_w 
	;
 
	insert into darf( 
				nr_sequencia, 
				cd_estabelecimento, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_apuracao,  
				cd_darf, 
				dt_vencimento, 
				nr_referencia, 
				vl_juros, 
				vl_multa, 
				ds_observacao, 
				dt_liberacao, 
				cd_tipo_credito, 
				cd_processo_dcomp, 
				ie_formalizacao_pedido, 
				vl_compensado_debito) 
		values ( 
				nr_seq_darf_w, 
				cd_estabelecimento_p, 
				clock_timestamp(), 
				'Tasy', 
				clock_timestamp(), 
				'Tasy', 
				dt_darf_w, 
				cd_darf_imposto_w, 
				dt_imposto_p, 
				null , 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null		 
				);
		 
	commit;
	 
	insert into darf_titulo_pagar( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_darf, 
					nr_titulo) 
			values (	 
					nextval('darf_titulo_pagar_seq'), 
					clock_timestamp(), 
					'Tasy', 
					clock_timestamp(), 
					'Tasy', 
					nr_seq_darf_w, 
					nr_titulo_p		 
					);
	 
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_darf_pelo_titulo ( nr_titulo_p bigint, cd_tributo_p bigint, dt_imposto_p timestamp, cd_estabelecimento_p bigint ) FROM PUBLIC;
