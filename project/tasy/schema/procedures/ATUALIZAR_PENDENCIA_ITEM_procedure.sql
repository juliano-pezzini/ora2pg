-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pendencia_item (nr_seq_item_p bigint, ie_pendencia_p text, nr_sequencia_p bigint) AS $body$
DECLARE


/*
* AV - Avaliações
* EHR - Templates
*/
qt_reg_w				bigint;
ie_tipo_pendencia_w		varchar(1);
nr_seq_template_w		bigint;


BEGIN

if (nr_sequencia_p > 0) and (nr_seq_item_p > 0)	then

    if (ie_pendencia_p = 'AV') then

		select	count(*)
		into STRICT	qt_reg_w
		from	pep_item_pendente
		where	nr_seq_avaliacao = nr_sequencia_p;

		if (qt_reg_w > 0) then
			update	pep_item_pendente
			set		nr_seq_item_orig_pront = nr_seq_item_p
			where	nr_seq_avaliacao = nr_sequencia_p;
		end if;

    elsif (ie_pendencia_p = 'EHR') then

		select  coalesce(max(ie_tipo_pendencia),'N')
		into STRICT	ie_tipo_pendencia_w
		from	pep_item_pendente
		where	nr_seq_ehr_reg = nr_sequencia_p;

		if (ie_tipo_pendencia_w = 'A') then

			select	nr_seq_template
			into STRICT	nr_seq_template_w
			from	ehr_reg_template
			where 	nr_seq_reg = nr_sequencia_p;

			if (consiste_se_gera_assinatura(nr_seq_template_w, nr_seq_item_p) = 'N') then
				delete from pep_item_pendente where	nr_seq_ehr_reg = nr_sequencia_p;
			else
				update	pep_item_pendente
				set		nr_seq_item_pront = nr_seq_item_p,
						nr_seq_item_orig_pront = nr_seq_item_p
				where	nr_seq_ehr_reg = nr_sequencia_p;
			end if;

		elsif (ie_tipo_pendencia_w <> 'N') then
			update	pep_item_pendente
			set		nr_seq_item_pront = nr_seq_item_p,
					nr_seq_item_orig_pront = nr_seq_item_p
			where	nr_seq_ehr_reg = nr_sequencia_p;
		end if;
   end if;

   commit;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pendencia_item (nr_seq_item_p bigint, ie_pendencia_p text, nr_sequencia_p bigint) FROM PUBLIC;
