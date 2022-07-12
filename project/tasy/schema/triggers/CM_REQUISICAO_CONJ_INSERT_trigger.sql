-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cm_requisicao_conj_insert ON cm_requisicao_conj CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cm_requisicao_conj_insert() RETURNS trigger AS $BODY$
declare

ie_vincular_cirurgia_w	varchar(1) := 'N';
nr_seq_requisicao_w	cm_requisicao.nr_sequencia%type;
nr_cirurgia_w		cirurgia.nr_cirurgia%type;

BEGIN

ie_vincular_cirurgia_w := obter_valor_param_usuario(410, 60, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

if (ie_vincular_cirurgia_w = 'S') then

	select	max(nr_seq_requisicao)
	into STRICT	nr_seq_requisicao_w
	from	cm_requisicao_item
	where	nr_sequencia = NEW.nr_seq_item_req;

	select	max(nr_cirurgia)
	into STRICT	nr_cirurgia_w
	from	cm_requisicao
	where	nr_sequencia = nr_seq_requisicao_w;

	update	cm_conjunto_cont
	set	nr_cirurgia = nr_cirurgia_w
	where	nr_sequencia = NEW.nr_seq_conj_real;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cm_requisicao_conj_insert() FROM PUBLIC;

CREATE TRIGGER cm_requisicao_conj_insert
	AFTER INSERT ON cm_requisicao_conj FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cm_requisicao_conj_insert();

