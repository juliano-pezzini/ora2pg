-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_serie_nf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_nota_orig_w			nota_fiscal.nr_nota_fiscal%type;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
cd_cgc_emitente_w		nota_fiscal.cd_cgc_emitente%type;
cd_estabelecimento_w		nota_fiscal.cd_estabelecimento%type;
cd_setor_digitacao_w		nota_fiscal.cd_setor_digitacao%type;
cd_operacao_nf_w			nota_fiscal.cd_operacao_nf%type;
NR_SEQUENCIA_NF_w		nota_fiscal.NR_SEQUENCIA_NF%type;
	
nr_nota_fiscal_w			nota_fiscal.nr_nota_fiscal%type;
ie_numero_nota_w			serie_nota_fiscal.ie_numero_nota%type;
nr_ultima_nf_w			serie_nota_fiscal.nr_ultima_nf%type;

ie_estab_serie_nf_w		parametro_compras.ie_estab_serie_nf%type;
IE_TRANSFERENCIA_ESTAB_w	operacao_nota.IE_TRANSFERENCIA_ESTAB%type;

qt_registro_w			bigint;
ds_erro_w			varchar(2000);
ie_sucesso_w			varchar(1);


BEGIN
begin
select	nr_nota_fiscal,
	cd_serie_nf,
	cd_cgc_emitente,
	cd_estabelecimento,
	cd_setor_digitacao,
	cd_operacao_nf
into STRICT	nr_nota_orig_w,
	cd_serie_nf_w,
	cd_cgc_emitente_w,
	cd_estabelecimento_w,
	cd_setor_digitacao_w,
	cd_operacao_nf_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;
exception
when others then
	cd_serie_nf_w	:=	null;
end;

begin
select	coalesce(IE_TRANSFERENCIA_ESTAB,'N')
into STRICT	IE_TRANSFERENCIA_ESTAB_w
from	operacao_nota
where	cd_operacao_nf = cd_operacao_nf_w;
exception
when others then
	IE_TRANSFERENCIA_ESTAB_w	:=	'N';
end;

select	coalesce(max(ie_estab_serie_nf),'N')
into STRICT	ie_estab_serie_nf_w
from	parametro_compras
where	cd_estabelecimento	= cd_estabelecimento_w;

lock table serie_nota_fiscal in exclusive mode;

select	count(*)
into STRICT	qt_registro_w
from	serie_nota_fiscal
where	cd_serie_nf 			= cd_serie_nf_w
and	cd_estabelecimento 		= cd_estabelecimento_w;

if (qt_registro_w > 0) then
	select	nr_ultima_nf + 1,
		ie_numero_nota,
		nr_ultima_nf
	into STRICT	nr_nota_fiscal_w,
		ie_numero_nota_w,
		nr_ultima_nf_w
	from	serie_nota_fiscal
	where	cd_serie_nf 			= cd_serie_nf_w
	and	cd_estabelecimento 		= cd_estabelecimento_w;



	if (ie_numero_nota_w = 'T') and (cd_setor_digitacao_w > 0) then
		
		select	count(*)
		into STRICT	qt_registro_w
		from	serie_nota_fiscal_setor
		where	cd_serie_nf = cd_serie_nf_w
		and	cd_estabelecimento = cd_estabelecimento_w
		and	cd_setor_atendimento = cd_setor_digitacao_w;
		
		if (qt_registro_w > 0) then				
			select	nr_ultima_nf +1,
				nr_ultima_nf
			into STRICT	nr_nota_fiscal_w,
				nr_ultima_nf_w
			from	serie_nota_fiscal_setor
			where	cd_serie_nf = cd_serie_nf_w
			and	cd_estabelecimento = cd_estabelecimento_w
			and	cd_setor_atendimento = cd_setor_digitacao_w;



		
		end if;	
	end if;
	
	if (nr_ultima_nf_w = nr_nota_orig_w) and (somente_numero(nr_nota_orig_w) > 0) then
		begin
		
		select	nr_nota_fiscal_w
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	nr_nota_fiscal = nr_nota_orig_w
		and	cd_estabelecimento = cd_estabelecimento_w
		and	nr_sequencia <> nr_sequencia_p  LIMIT 1;
		exception
		when others then
			nr_nota_fiscal_w := nr_nota_orig_w;
		end;		
	end if;		
	
	select	count(*)
	into STRICT	qt_registro_w
	from	nota_fiscal_aidf
	where	cd_estabelecimento 	= cd_estabelecimento_w
	and	cd_serie_nf 		= cd_serie_nf_w;

	if (qt_registro_w > 0) then
		select	count(*)
		into STRICT	qt_registro_w
		from	nota_fiscal_aidf
		where	cd_estabelecimento 	= cd_estabelecimento_w
		and	cd_serie_nf 		= cd_serie_nf_w
		and	nr_nota_fiscal_w 	>= nr_nota_ini
		and 	nr_nota_fiscal_w 	<= nr_nota_fim;
		
		if (qt_registro_w = 0) then
			/*(-20011,	'Sem autorizacao para informar este numero de nota fiscal (' || nr_nota_fiscal_w || '), ' || chr(10) || chr(13) || 
							'verifique o cadastro de autorizacoes(AIDF) nos cadastros de estoque.');*/
			CALL wheb_mensagem_pck.exibir_mensagem_abort(195306,'NR_NOTA_FISCAL_W='||nr_nota_fiscal_w);			
		end if;
	end if;
	
	/*Se for nota fiscal entre estabelecimentos*/

	if (ie_transferencia_estab_w = 'S') then
		begin		
		ie_sucesso_w	:=	'N';
		
		if	((somente_numero(nr_nota_orig_w) > 0) and (somente_numero(nr_nota_fiscal_w) > somente_numero(nr_nota_orig_w))) then
			nr_nota_fiscal_w	:=	nr_nota_orig_w;


		end if;
		
		while(ie_sucesso_w = 'N') loop
			begin
				begin
					select	'N'
					into STRICT	ie_sucesso_w
					from	nota_fiscal
					where	cd_estabelecimento 	= cd_estabelecimento_w
					and		cd_cgc_emitente		= cd_cgc_emitente_w
					and		cd_serie_nf 		= cd_serie_nf_w
					and		nr_nota_fiscal 		= nr_nota_fiscal_w
					and (ie_situacao = '1' or (ie_situacao = '3' and (nr_danfe IS NOT NULL AND nr_danfe::text <> '')))
					and		nr_sequencia		<> nr_sequencia_p
					and		(dt_atualizacao_estoque IS NOT NULL AND dt_atualizacao_estoque::text <> '')  LIMIT 1;
				exception
				when others then
					ie_sucesso_w	:=	'S';
				end;
			
			if (ie_sucesso_w = 'N') then
				nr_nota_fiscal_w	:=	somente_numero(nr_nota_fiscal_w) + 1;



			end if;
			end;
		end loop;
		end;
	end if;

	begin	
	if (ie_numero_nota_w = 'T') then		
		update	serie_nota_fiscal_setor
		set	nr_ultima_nf 		= nr_nota_fiscal_w
		where	cd_serie_nf 		= cd_serie_nf_w
		and	cd_estabelecimento 	= cd_estabelecimento_w
		and	cd_setor_atendimento	= cd_setor_digitacao_w
		and	somente_numero(nr_nota_fiscal_w) > somente_numero(nr_ultima_nf);
	
		update	nota_fiscal
		set	nr_nota_fiscal		= nr_nota_fiscal_w
		where	nr_sequencia		= nr_sequencia_p;
	
	elsif (ie_numero_nota_w = 'S') then
		
		if (coalesce(ie_estab_serie_nf_w,'N') = 'S') then
			update	serie_nota_fiscal
			set	nr_ultima_nf 		= nr_nota_fiscal_w
			where	cd_serie_nf 		= cd_serie_nf_w
			and	cd_estabelecimento in (SELECT	z.cd_estabelecimento
							from	estabelecimento z
							where	z.cd_cgc = cd_cgc_emitente_w)
			and	somente_numero(nr_nota_fiscal_w) > somente_numero(nr_ultima_nf);


		else
			update	serie_nota_fiscal
			set	nr_ultima_nf 		= nr_nota_fiscal_w
			where	cd_serie_nf 		= cd_serie_nf_w
			and	cd_estabelecimento 	= cd_estabelecimento_w
			and	somente_numero(nr_nota_fiscal_w) > somente_numero(nr_ultima_nf);

		end if;		
	



		update	nota_fiscal
		set	nr_nota_fiscal		= nr_nota_fiscal_w
		where	nr_sequencia		= nr_sequencia_p;
	
	elsif (ie_numero_nota_w = 'O') then
	
		select	coalesce(max(ie_numero_nota),'S')
		into STRICT	ie_numero_nota_w
		from	operacao_nota
		where	cd_operacao_nf = cd_operacao_nf_w;
		
		if (ie_numero_nota_w = 'S') then
	
			update	serie_nota_fiscal
			set	nr_ultima_nf 		= nr_nota_fiscal_w
			where	cd_serie_nf 		= cd_serie_nf_w
			and	cd_estabelecimento 	= cd_estabelecimento_w
			and	somente_numero(nr_nota_fiscal_w) > somente_numero(nr_ultima_nf);

			update	nota_fiscal
			set	nr_nota_fiscal		= nr_nota_fiscal_w
			where	nr_sequencia		= nr_sequencia_p;
		end if;
	end if;
	exception when others then
		ds_erro_w	:= substr(sqlerrm(SQLSTATE),1,1000);
		--Ja existe uma nota fiscal deste emitente cadastrada com o numero #@NR_NOTA_FISCAL_W#@.

		--Verifique o cadastro da serie (ultima nf), pois o numero da nota fiscal e atualizado pelo sistema.

		--#@DS_ERRO_W#@
		CALL wheb_mensagem_pck.exibir_mensagem_abort(195307,	'NR_NOTA_FISCAL_W=' || nr_nota_fiscal_w || ';' ||
								'DS_ERRO_W=' || ds_erro_w);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_serie_nf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

