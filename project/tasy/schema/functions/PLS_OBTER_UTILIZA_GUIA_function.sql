-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_utiliza_guia (nr_seq_guia_p pls_guia_plano.nr_sequencia%type) RETURNS varchar AS $body$
BEGIN
/* Não é mais utilizada. A substituta é a pls_conta_autor_pck.pls_obter_ie_utilizado_guia(nr_seq_guia_p, nr_seq_guia_proc_p, nr_seq_guia_mat_p)*/

return	null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_utiliza_guia (nr_seq_guia_p pls_guia_plano.nr_sequencia%type) FROM PUBLIC;

