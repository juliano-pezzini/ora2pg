-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_conta_zerada ( nr_interno_conta_p bigint , nm_usuario_p text ) AS $body$
DECLARE

	qt_contas_w bigint;
	ds_erro_w  varchar(255);

BEGIN
	if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then 
		begin 
			select count(*) 
			into STRICT qt_contas_w 
			from valores_atend_paciente_v a 
			where a.nr_interno_conta = nr_interno_conta_p;
			if ( qt_contas_w     = 0) then 
				begin 
				delete from conta_paciente where nr_interno_conta = nr_interno_conta_p;
				exception 
				when others then 
					ds_erro_w:= wheb_mensagem_pck.get_texto(305315);
					--Ocorreu um erro ao deletar o registro da tabela conta_paciente 
				end;
			end if;
			commit;
		end;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_conta_zerada ( nr_interno_conta_p bigint , nm_usuario_p text ) FROM PUBLIC;

