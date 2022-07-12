-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.validar_inserir_rpr_resp ( ds_hash_p pls_rpr_resposta.ds_hash%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Valida se pode importar uma nova resposta

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]   Objetos do dicionario [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

qt_hash_w	integer;

BEGIN

select	count(1)
into STRICT	qt_hash_w
from	pls_rpr_resposta
where	ds_hash	= upper(ds_hash_p);

if (coalesce(qt_hash_w, 0) > 0) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(857329);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.validar_inserir_rpr_resp ( ds_hash_p pls_rpr_resposta.ds_hash%type) FROM PUBLIC;
