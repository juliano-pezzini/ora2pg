-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qsm_get_status_doc (nr_seq_episodio_p bigint) RETURNS varchar AS $body$
DECLARE


/*
OK -> All documents are OK
IP -> Any document in progress
TD -> Any document with things to do
*/
const_documents_ok 			varchar(2) := 'OK';
const_documents_error 		varchar(2) := 'TD';
const_documents_na			varchar(2) := 'NA';
ds_retorno_w				varchar(2);
nr_seq_document_w			episodio_pac_document.nr_sequencia%type;
ie_status_w					episodio_pac_doc_status.ie_status%type;


C01 CURSOR(nr_seq_episodio_pc bigint) FOR
	SELECT d.nr_sequencia nr_seq_document
	from 	wl_worklist a,
			wl_item b,
			episodio_pac_document d
	where 	a.nr_seq_item = b.nr_sequencia
	and		a.nr_seq_document = d.nr_sequencia
	and	  	b.cd_categoria = 'QA'
	and		coalesce(a.dt_final_real::text, '') = ''
	and  	d.nr_seq_episodio = nr_seq_episodio_pc;

BEGIN

	for r_C01_w in C01(nr_seq_episodio_p) loop
		begin
			select	coalesce(max(ie_status),'NA')
			into STRICT	ie_status_w
			from	episodio_pac_doc_status
			where	nr_seq_document = r_C01_w.nr_seq_document
			and		cd_perfil = obter_perfil_ativo
			order by coalesce(max(ie_status),'NA');

		if (ie_status_w = 'ERROR')then
			return const_documents_error;
		elsif (ie_status_w = 'OK')then
			return const_documents_ok;
		else
			ds_retorno_w := const_documents_na;
		end if;
		end;
	end loop;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qsm_get_status_doc (nr_seq_episodio_p bigint) FROM PUBLIC;

