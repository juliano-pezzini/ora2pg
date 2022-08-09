-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_bloq_escritu ( nr_titulo_p bigint, ie_origem_via_p text) AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: chamada pleo delphi para Chmar a rotina Gerar_Bloqueto_Tit_Rec e em seguida fechara transação 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 
 

BEGIN 
--esta rotina foi criado pois a rotina a baixa nao pode ter o comit dentro, e por isso foi criado esta para commitar no final 
CALL gerar_bloqueto_tit_rec(nr_titulo_p, ie_origem_via_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_bloq_escritu ( nr_titulo_p bigint, ie_origem_via_p text) FROM PUBLIC;
