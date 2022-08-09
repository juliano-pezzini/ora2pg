-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_vinc_bonificacao ( nr_seq_bonificacao_p bigint, vl_bonificacao_p bigint, tx_bonificacao_p bigint, cd_funcao_p bigint, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


ie_alteracao_vinculacao_w 	varchar(1);
vl_minimo_w			double precision;
vl_maximo_w			double precision;
tx_minimo_w			double precision;
tx_maximo_w			double precision;
ie_funcao_w			bigint;
ie_tipo_item_w			varchar(50);
qt_regra_w			bigint;


BEGIN

if (coalesce(nr_seq_bonificacao_p,0) <> 0) then

	begin
	select  ie_alteracao_vinculacao,
		vl_minimo,
		vl_maximo,
		tx_minimo,
		tx_maximo
	into STRICT	ie_alteracao_vinculacao_w,
		vl_minimo_w,
		vl_maximo_w,
		tx_minimo_w,
		tx_maximo_w
	from    pls_bonificacao
	where   nr_sequencia = nr_seq_bonificacao_p;
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265922,'');
		--Mensagem: Bonificação não encontrada. Favor verifique o cadastro da mesma!
	end;

	if	((ie_alteracao_vinculacao_w = 'N') or (coalesce(ie_alteracao_vinculacao_w::text, '') = '')) and
		((tx_bonificacao_p <> 0) or (vl_bonificacao_p <> 0)) then
			ds_erro_p	:= wheb_mensagem_pck.get_texto(280723);
	end if;

	if (ie_alteracao_vinculacao_w = 'S') then
		if	(vl_minimo_w IS NOT NULL AND vl_minimo_w::text <> '' AND vl_bonificacao_p < vl_minimo_w AND vl_bonificacao_p <> 0) then
				ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280727, 'VL_MINIMO_P=' || vl_minimo_w);
		end if;
		if	(vl_maximo_w IS NOT NULL AND vl_maximo_w::text <> '' AND vl_bonificacao_p > vl_maximo_w) then
				ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280728, 'VL_MAXIMO_P=' || vl_maximo_w);
		end if;
		if	(tx_minimo_w IS NOT NULL AND tx_minimo_w::text <> '' AND tx_bonificacao_p < tx_minimo_w AND tx_bonificacao_p <> 0) then
				ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280729, 'TX_MINIMA_P=' || tx_minimo_w);
		end if;
		if	(tx_maximo_w IS NOT NULL AND tx_maximo_w::text <> '' AND tx_bonificacao_p > tx_maximo_w) then
				ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280730, 'TX_MAXIMA_P=' || tx_maximo_w);
		end if;
	end if;

	select	max(nr_sequencia)
	into STRICT	ie_funcao_w
	from	pls_bonificacao_liberacao
	where	pls_obter_se_bonific_funcao(cd_funcao_p,clock_timestamp(),nr_seq_bonificacao_p, nm_usuario_p) = 'S'
	and	cd_funcao = cd_funcao_p
	and	nr_seq_bonificacao = nr_seq_bonificacao_p;

	if (coalesce(ie_funcao_w::text, '') = '') then
		ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280731);
	end if;

	if (cd_funcao_p = 1264) then
		select  max(ie_tipo_item)
		into STRICT	ie_tipo_item_w
		from    pls_bonificacao_regra
		where   nr_seq_bonificacao = nr_seq_bonificacao_p;

		select	count(*)
		into STRICT	qt_regra_w
		from    pls_bonificacao_regra
		where   nr_seq_bonificacao = nr_seq_bonificacao_p;

		if (ie_tipo_item_w <> '15' or qt_regra_w = 0) then
			ds_erro_p  := ds_erro_p || wheb_mensagem_pck.get_texto(280732);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_vinc_bonificacao ( nr_seq_bonificacao_p bigint, vl_bonificacao_p bigint, tx_bonificacao_p bigint, cd_funcao_p bigint, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
