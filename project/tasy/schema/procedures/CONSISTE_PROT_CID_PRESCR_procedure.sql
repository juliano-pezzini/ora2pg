-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_prot_cid_prescr ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_perfil_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

nr_seq_regra_w		bigint;
cd_doenca_cid_w		varchar(10);
cd_tipo_protocolo_w bigint;
ds_protocolo_w		varchar(255);
ds_protocolos_w		varchar(2000);
qt_exite_w			bigint;
/* Cursor para as regras */

c01 CURSOR FOR
SELECT	nr_sequencia
from		rep_regra_cid
where	Obter_Se_Cid_Atendimento(nr_atendimento_p,cd_doenca_cid) = 'S'
and		cd_perfil		= cd_perfil_p;
/* Cursor para buscar os protocolos que não estão na prescrição */

c02 CURSOR FOR
SELECT	distinct Obter_desc_protocolo(cd_protocolo)
from		rep_regra_cid_protocolo
where	nr_seq_regra = nr_seq_regra_w
and		obter_se_existe_prot_prescr(cd_protocolo,nr_prescricao_p) = 'N';


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	/* Verifica se existe alguma regra cadastrada */

	select	count(*)
	into STRICT		qt_exite_w
	from		rep_regra_cid
	where	Obter_Se_Cid_Atendimento(nr_atendimento_p,cd_doenca_cid) = 'S'
	and		cd_perfil		= cd_perfil_p;
	/* Se houver verifica se tem algum algum item */

	if (qt_exite_w > 0) then
		open c01;
		loop
		fetch c01 into nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			open c02;
			loop
			fetch c02 into ds_protocolo_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				if (ds_protocolos_w IS NOT NULL AND ds_protocolos_w::text <> '') then
					ds_protocolos_w := substr(ds_protocolos_w||chr(13)||ds_protocolo_w,1,2000);
				else
					ds_protocolos_w := substr(ds_protocolo_w,1,2000);
				end if;
				end;
			end loop;
			close c02;
			end;
		end loop;
		close c01;
	end if;

	if (ds_protocolos_w IS NOT NULL AND ds_protocolos_w::text <> '') then
		ds_erro_p := substr(wheb_mensagem_pck.get_texto(278077, 'DS_PROTOCOLOS_P=' || ds_protocolos_w),1,255);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_prot_cid_prescr ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_perfil_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

