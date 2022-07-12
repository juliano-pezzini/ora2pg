-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS movto_cartao_cr_trib_after ON movto_cartao_cr_trib CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_movto_cartao_cr_trib_after() RETURNS trigger AS $BODY$
declare
vl_imposto_w		movto_cartao_cr_parcela.vl_imposto%type;
nr_sequencia_w		movto_cartao_cr_parcela.nr_sequencia%type;
vl_despesa_W		movto_cartao_cr_parcela.vl_despesa%type;

/*Cursor para buscar as parcelas do cartao.*/
	
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
			a.vl_despesa
	from	movto_cartao_cr_parcela a
	where	a.nr_seq_movto	= OLD.nr_seq_movto_cartao
	order by a.nr_sequencia;
	
	
/*Trigger criada devido a necessidade de atualizar o valor do imposto na parcela sempre que um tributo for excluido*/


BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (OLD.cd_tributo is not null) and (OLD.tx_tributo is not null) then

	open C01;
	loop
	fetch C01 into	
		nr_sequencia_w,
		vl_despesa_W;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		
			if (coalesce(vl_despesa_w,0) > 0) and (coalesce(OLD.tx_tributo,0) > 0) then
			
					vl_imposto_w := (vl_despesa_w * (OLD.tx_tributo / 100))*-1;
					
					update	movto_cartao_cr_parcela a
					set		a.vl_imposto	= coalesce(a.vl_imposto,0) + coalesce(vl_imposto_w,0)
					where	a.nr_sequencia	= nr_sequencia_w
					and		a.nr_seq_movto	= OLD.nr_seq_movto_cartao;	
			end if;		
		
		end;
	end loop;
	close C01;
end if;
end if;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_movto_cartao_cr_trib_after() FROM PUBLIC;

CREATE TRIGGER movto_cartao_cr_trib_after
	AFTER DELETE ON movto_cartao_cr_trib FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_movto_cartao_cr_trib_after();

