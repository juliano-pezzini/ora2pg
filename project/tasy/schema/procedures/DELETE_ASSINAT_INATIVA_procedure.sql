-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_assinat_inativa ( nm_tabela_p text, nm_atributo_p text, nr_sequencia_P text) AS $body$
DECLARE


ds_comando_w		varchar(2000);
nm_campo_w		varchar(50);
nm_int_ref_w		varchar(50);
cd_tipo_registro_w	varchar(4);
ie_escala_w		varchar(15);


BEGIN

if (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') and (nr_sequencia_P IS NOT NULL AND nr_sequencia_P::text <> '') then
	begin

	select 	coalesce(max(nm_integridade_referencial),null)
	into STRICT	nm_int_ref_w
	from	integridade_referencial
	where	nm_tabela = 'PEP_ITEM_PENDENTE'
	and	upper(nm_tabela_referencia) = upper(nm_tabela_p);

	if (nm_int_ref_w IS NOT NULL AND nm_int_ref_w::text <> '') then

		select 	coalesce(max(nm_atributo),null)
		into STRICT	nm_campo_w
		from	integridade_atributo
		where	nm_tabela = 'PEP_ITEM_PENDENTE'
		and	upper(nm_integridade_referencial) = upper(nm_int_ref_w);

		if (nm_campo_w IS NOT NULL AND nm_campo_w::text <> '') then
			ds_comando_w :=	' delete  pep_item_pendente where '||nm_campo_w|| ' = ' ||nr_sequencia_P;
			CALL exec_sql_dinamico('Tasy', ds_comando_w);
			commit;
		end if;
	else

		ie_escala_w := obter_tipo_registro_pendencia(upper(nm_tabela_p));

		if (cd_tipo_registro_w IS NOT NULL AND cd_tipo_registro_w::text <> '') then

			if (cd_tipo_registro_w = 'PM') then
				delete from pep_item_pendente
				where  nr_parecer = nr_sequencia_P;
				commit;
			elsif (cd_tipo_registro_w = 'EHR') then
				delete from pep_item_pendente
				where nr_seq_ehr_reg = nr_sequencia_P;
				commit;
			elsif (cd_tipo_registro_w = 'REC') then
				delete from pep_item_pendente
				where nr_seq_receita = nr_sequencia_P;
				commit;
			elsif (cd_tipo_registro_w = 'RECAMB') then
				delete  FROM pep_item_pendente
				where nr_seq_receita_amb = nr_sequencia_P;
				commit;
			elsif (cd_tipo_registro_w = 'ESC') then
				if (ie_escala_w IS NOT NULL AND ie_escala_w::text <> '') then
					delete from pep_item_pendente
					where nr_seq_escala = nr_sequencia_P
					and ie_escala =  ie_escala_w;
					commit;
				end if;
			else
				delete from pep_item_pendente
				where nr_seq_registro = nr_sequencia_P
				and ie_tipo_registro =  cd_tipo_registro_w;
				commit;
			end if;
		end if;

	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_assinat_inativa ( nm_tabela_p text, nm_atributo_p text, nr_sequencia_P text) FROM PUBLIC;

