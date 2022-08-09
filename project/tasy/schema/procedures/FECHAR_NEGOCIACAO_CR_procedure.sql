-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fechar_negociacao_cr ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
 
ds_observacao_w		varchar(3999);
ds_titulos_w		varchar(1000) := null;
cd_cgc_w		varchar(14);
cd_pessoa_fisica_w	varchar(10);
ds_titulo_w		varchar(10);
ie_titulo_negociado_w	varchar(1);
vl_vencimento_w		double precision;
vl_debito_w		double precision;
vl_saldo_negociacao_w	double precision;
nr_seq_boleto_w		bigint;
nr_seq_debito_w		bigint;
nr_titulo_w		bigint;
cd_portador_w		bigint;
cd_tipo_taxa_juro_w	bigint;
cd_tipo_taxa_multa_w	bigint;
nr_negociacao_w		bigint;
qt_registro_w		bigint;
cd_tipo_portador_w	integer;
cd_moeda_padrao_w	integer;
cd_estabelecimento_w	smallint;
dt_fechamento_w		timestamp;
dt_recebimento_w	timestamp	:= null;
dt_vencimento_w		timestamp;
dt_debito_w		timestamp;
dt_negociacao_w		timestamp;
ie_observacao_w		varchar(1);
vl_saldo_titulo_w	titulo_receber.vl_saldo_titulo%type;
ie_dt_contab_tit_neg_w	varchar(1);
qt_titulo_w				bigint;
dt_contabil_w			titulo_receber.dt_contabil%type;

/* Títulos baixados na negociacao */
 
C01 CURSOR FOR 
	SELECT	a.nr_titulo 
	from	titulo_rec_negociado a 
	where	a.nr_seq_negociacao	= nr_sequencia_p 
	order by 
		a.nr_titulo;
	
/* Títulos gerados à partir da negociacao */
 
C02 CURSOR FOR 
	SELECT	a.nr_titulo 
	from	titulo_receber a 
	where	a.nr_seq_negociacao_origem	= nr_sequencia_p 
	
union
 
	SELECT	a.nr_titulo 
	from	negociacao_cr_boleto a 
	where	a.nr_seq_negociacao	= nr_sequencia_p 
	
union
 
	select	a.nr_titulo 
	from	negociacao_cr_deb_cc a 
	where	a.nr_seq_negociacao	= nr_sequencia_p;

BEGIN
 
ie_observacao_w := Obter_Param_Usuario(5514, 19, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_observacao_w);
ie_dt_contab_tit_neg_w := Obter_Param_Usuario(5514, 23, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_dt_contab_tit_neg_w);
 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	/* Obter dados da negociação */
 
	select	a.dt_negociacao, 
		a.dt_fechamento, 
		a.cd_estabelecimento, 
		a.cd_pessoa_fisica, 
		a.cd_cgc 
	into STRICT	dt_negociacao_w, 
		dt_fechamento_w, 
		cd_estabelecimento_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	negociacao_cr a 
	where	a.nr_sequencia	= nr_sequencia_p;
	 
	/* Consistências */
 
	if (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(175678);
	end if;
	 
	vl_saldo_negociacao_w	:= obter_valores_negociacao_cr(nr_sequencia_p,'VS');
	 
	if (vl_saldo_negociacao_w > 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(175679,'VL_SALDO=' || vl_saldo_negociacao_w);
	elsif (obter_valores_negociacao_cr(nr_sequencia_p,'VS') < 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(175680);
	end if;
	 
	/* Se a negociação não envolveu valores monetários já deve atualizar a 
	data de recebimento no caixa e gerar os títulos */
 
	select	sum(qt_registro) 
	into STRICT	qt_registro_w 
	from (SELECT	count(*) qt_registro 
		from	negociacao_cr_cheque 
		where	nr_seq_negociacao	= nr_sequencia_p 
		
union all
 
		SELECT	count(*) qt_registro 
		from	negociacao_cr_cartao 
		where	nr_seq_negociacao	= nr_sequencia_p 
		
union all
 
		select	count(*) qt_registro 
		from	negociacao_cr_especie 
		where	nr_seq_negociacao	= nr_sequencia_p) alias4;
		 
	if (qt_registro_w = 0) then 
		dt_recebimento_w	:= clock_timestamp();
	end if;
	 
	CALL gerar_titulos_negociacao_cr(nr_sequencia_p,nm_usuario_p);
	 
	/* Obter número da negociação */
 
	select	coalesce(max(a.nr_negociacao),0) + 1 
	into STRICT	nr_negociacao_w 
	from	negociacao_cr a 
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
	 
	select	coalesce(max(ie_titulo_negociado),'N') 
	into STRICT	ie_titulo_negociado_w 
	from	parametro_contas_receber 
	where	cd_estabelecimento	= cd_estabelecimento_w;
	 
	update	negociacao_cr 
	set	dt_fechamento	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		nr_negociacao	= nr_negociacao_w, 
		dt_recebimento	= dt_recebimento_w, 
		ie_status	= 'AP' 
	where	nr_sequencia	= nr_sequencia_p;
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_titulos_w	:= null;
		open C02;
		loop 
		fetch C02 into	 
			ds_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			if (coalesce(ds_titulos_w::text, '') = '') then 
				ds_titulos_w	:= substr(ds_titulo_w,1,1000);
			else 
				ds_titulos_w	:= substr(ds_titulos_w || ', ' || ds_titulo_w,1,1000);
			end if;
			end;
		end loop;
		close C02;
		 
		/*ds_observacao_w	:= 'Título baixado pela negociação ' || nr_negociacao_w || ' e gerado(s) os título(s) ' || 
				ds_titulos_w || ' à partir da mesma.';*/
 
		ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(302714,'NR_NEGOCIACAO_W='||nr_negociacao_w||';DS_TITULOS_W='||ds_titulos_w),1,3999);
 
				 
		update	titulo_receber 
		set	ds_observacao_titulo	= substr(ds_observacao_titulo || ds_observacao_w,1,3999) 
		where	nr_titulo		= nr_titulo_w;
		 
		if (ie_titulo_negociado_w = 'S') then --Se parametrizado, altera para Transferido quando liquida o título pela negociação 
			update	titulo_receber 
			set	ie_situacao	= '5' 
			where	nr_titulo	= nr_titulo_w 
			and	vl_saldo_titulo	= 0;
		end if;
		 
		select	sum(vl_saldo_titulo) 
		into STRICT	vl_saldo_titulo_w 
		from	titulo_receber 
		where	nr_titulo = nr_titulo_w;
		 
		select	max(dt_contabil) 
		into STRICT	dt_contabil_w 
		from	titulo_receber 
		where	nr_titulo = nr_titulo_w;
		 
		if (vl_saldo_titulo_w = 0) then 
			CALL liberar_titulo_orgao_cobr(nr_titulo_w,nm_usuario_p);
		end if;		
		 
		end;
	end loop;
	close C01;
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		if ( coalesce(ie_observacao_w,'N') = 'S' ) then 
			--ds_observacao_w	:= 'Título gerado através da negociação ' || nr_negociacao_w || '. '||substr(obter_titulos_negociados(nr_sequencia_p),1,4000); 
			ds_observacao_w	:= wheb_mensagem_pck.get_texto(302718,'NR_NEGOCIACAO_W='||nr_negociacao_w) || substr(obter_titulos_negociados(nr_sequencia_p),1,4000);		
		else 
			--ds_observacao_w	:= 'Título gerado através da negociação ' || nr_negociacao_w || '.'; 
			ds_observacao_w	:= wheb_mensagem_pck.get_texto(302718,'NR_NEGOCIACAO_W='||nr_negociacao_w);
		end if;
				 
		update	titulo_receber 
		set	ds_observacao_titulo	= substr(ds_observacao_titulo || ds_observacao_w,1,3999) 
		where	nr_titulo		= nr_titulo_w;
 
		if ( coalesce(ie_dt_contab_tit_neg_w,'N') = 'S' ) then 
			/*Verifica qts titulos estao sendo negociados*/
 
			select 	count(*) 
			into STRICT	qt_titulo_w 
			from	titulo_rec_negociado a 
			where	a.nr_seq_negociacao	= nr_sequencia_p;
 
			/*se tiver apenas um negociado, irá buscar a data contabil dele para atualizar nos titulos gerados na negociacao.*/
 
			if (qt_titulo_w = 1) then 
 
				if (dt_contabil_w IS NOT NULL AND dt_contabil_w::text <> '') then 
				 
					update	titulo_receber 
					set		dt_contabil = dt_contabil_w 
					where	nr_titulo	= nr_titulo_w;
				 
				end if;
			 
			end if;
		 
		end if;	
		 
		end;
	end loop;
	close C02;
	 
	--atualizar_valores_neg_cr(nr_sequencia_p,nm_usuario_p,'N'); Retireii devido a OS 676838, pois ja chama essa rotina quando insere os titulos na negociacao, onde gera as taxas. 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fechar_negociacao_cr ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
