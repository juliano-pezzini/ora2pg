-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_lote_dmed ( nr_seq_dmed_mensal_p bigint, ie_opcao_p text, ie_verificar_lote_anterior_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	IE_OPCAO_P
		G - Realizar a consistência ao gerar o lote mensal da DMED;
		D - Realizar a consistência ao desfazer o lote mensal da DMED.

	IE_VERIFICAR_LOTE_ANTERIOR_P
		Parâmetro  5500 - [43]  - DMED - Permitir gerar/desfazer lotes mensais, sem consistência da sequência do mês
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_estabelecimento_w		dmed_mensal.cd_estabelecimento%type;
dt_referencia_w			dmed_mensal.dt_referencia%type;
qt_registros_w			bigint;


BEGIN
ds_retorno_p	:= '';

if (nr_seq_dmed_mensal_p IS NOT NULL AND nr_seq_dmed_mensal_p::text <> '') then
	select	dt_referencia,
		cd_estabelecimento
	into STRICT	dt_referencia_w,
		cd_estabelecimento_w
	from	dmed_mensal
	where	nr_sequencia	= nr_seq_dmed_mensal_p;

	if (ie_opcao_p = 'G') then
		if (ie_verificar_lote_anterior_p = 'S') then
			select	count(1)
			into STRICT	qt_registros_w
			from	dmed_mensal
			where	cd_estabelecimento	= cd_estabelecimento_w
			and	dt_referencia		< dt_referencia_w
			and	coalesce(dt_geracao::text, '') = ''  LIMIT 1;

			if (qt_registros_w > 0) then
				ds_retorno_p	:= 'Não foi possível gerar o lote, pois há ao menos um lote com data de referência anterior e que ainda não foi gerado.';
			end if;
		end if;
	elsif (ie_opcao_p = 'D') then
		if (ie_verificar_lote_anterior_p = 'S') then
			select	count(1)
			into STRICT	qt_registros_w
			from	dmed_mensal
			where	cd_estabelecimento	= cd_estabelecimento_w
			and	dt_referencia		> dt_referencia_w
			and	(dt_geracao IS NOT NULL AND dt_geracao::text <> '')  LIMIT 1;

			if (qt_registros_w > 0) then
				ds_retorno_p	:= 'Não foi possível desfazer o lote, pois há ao menos um lote com data de referência posterior e que ainda não foi desfeito.';
			end if;
		end if;

		-- Verificar se a sequencia  mensal já está vinculado a um lote anual
		select	count(1)
		into STRICT	qt_registros_w
		from	dmed_agrupar_lote
		where	nr_seq_dmed_mensal	= nr_seq_dmed_mensal_p  LIMIT 1;

		if (qt_registros_w > 0) then --
			ds_retorno_p	:= 'Não foi possível desfazer o lote, pois este lote já está vinculado a um lote anual.';
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_lote_dmed ( nr_seq_dmed_mensal_p bigint, ie_opcao_p text, ie_verificar_lote_anterior_p text, ds_retorno_p INOUT text) FROM PUBLIC;

