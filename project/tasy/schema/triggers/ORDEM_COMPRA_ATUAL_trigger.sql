-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_atual ON ordem_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_atual() RETURNS trigger AS $BODY$
DECLARE

nr_cot_compra_w		bigint;
nr_solic_compra_w		bigint;
qt_existe_w			integer;
ds_historico_w		ordem_compra_hist.ds_historico%type;
ds_estab_antigo_w	varchar(255);
ds_estab_novo_w		varchar(255);


C01 CURSOR FOR
SELECT	distinct
	nr_cot_compra
from	ordem_compra_item
where	nr_ordem_compra = NEW.nr_ordem_compra;

c02 CURSOR FOR
SELECT	distinct nr_solic_compra
from (
	SELECT	nr_solic_compra
	from	cot_compra_item
	where	nr_cot_compra = nr_cot_compra_w
	and	nr_solic_compra > 0
	
union

	select	nr_solic_compra
	from	cot_compra_solic_agrup
	where	nr_cot_compra = nr_cot_compra_w
	and	nr_solic_compra > 0) alias0;
BEGIN
  BEGIN

if (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then

	CALL inserir_historico_ordem_compra(
		NEW.nr_ordem_compra,
		'S',
		wheb_mensagem_pck.get_texto(306352) /*'Liberação da ordem de compra'*/
,
		wheb_mensagem_pck.get_texto(306353) /*'A ordem de compra foi liberada para aprovação.'*/
,
		NEW.nm_usuario);
end if;

BEGIN

select	count(*)
into STRICT	qt_existe_w
from	nota_fiscal_item
where 	nr_ordem_compra = NEW.nr_ordem_compra;

exception when others then
	qt_existe_w := 0;
end;

if	((NEW.nr_seq_nf_repasse is not null) or (qt_existe_w > 0)) and (coalesce(OLD.cd_estabelecimento,0) <> coalesce(NEW.cd_estabelecimento,0)) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(360562); /*Não é permitido alterar o estabelecimento em ordens de compra que já possuem nota fiscal*/
end if;

if (coalesce(OLD.cd_estabelecimento,0) <> coalesce(NEW.cd_estabelecimento,0)) then

	select	obter_nome_estab(OLD.cd_estabelecimento),
		obter_nome_estab(NEW.cd_estabelecimento)
	into STRICT	ds_estab_antigo_w,
		ds_estab_novo_w
	;

	ds_historico_w := Wheb_mensagem_pck.get_Texto(360645,
							'CD_ESTAB_OLD_W='|| ds_estab_antigo_w||
							';CD_ESTAB_NEW_W='||ds_estab_novo_w);

	CALL inserir_historico_ordem_compra(
		NEW.nr_ordem_compra,
		'S',
		Wheb_mensagem_pck.get_Texto(360643), /* Troca de estabelecimento */
		ds_historico_w,
		NEW.nm_usuario);

end if;

if (OLD.dt_liberacao is not null) and (NEW.dt_liberacao is null) then
	CALL inserir_historico_ordem_compra(
		NEW.nr_ordem_compra,
		'S',
		Wheb_mensagem_pck.get_Texto(300822), /* Estorno da liberação */
		substr(dbms_utility.format_call_stack,1,2000),
		NEW.nm_usuario);
end if;

if (OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) and (NEW.dt_baixa is null) then

	CALL inserir_historico_ordem_compra(
		NEW.nr_ordem_compra,
		'S',
		wheb_mensagem_pck.get_texto(306354) /*'Aprovação da ordem de compra'*/
,
		wheb_mensagem_pck.get_texto(306355) /*'A ordem de compra foi aprovada.'*/
,
		NEW.nm_usuario);

	open C01;
	loop
	fetch C01 into
		nr_cot_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN

		open C02;
		loop
		fetch C02 into
			nr_solic_compra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			BEGIN
			BEGIN
			CALL gerar_hist_solic_sem_commit(
				nr_solic_compra_w,
				wheb_mensagem_pck.get_texto(306354) /*'Aprovação da ordem de compra'*/
,
				/*Aprovação da ordem de compra #@NR_ORDEM_COMPRA#@, que foi originada através desta solicitação de compras.*/

				wheb_mensagem_pck.get_texto(306357, 'NR_ORDEM_COMPRA=' || NEW.nr_ordem_compra),
				'AOC',
				NEW.nm_usuario);
			exception
			when others then
				null;
			end;

			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;
end if;

  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_atual() FROM PUBLIC;

CREATE TRIGGER ordem_compra_atual
	BEFORE UPDATE ON ordem_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_atual();
