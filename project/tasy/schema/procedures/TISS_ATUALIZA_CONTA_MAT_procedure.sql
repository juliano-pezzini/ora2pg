-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualiza_conta_mat (nr_seq_material_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* 
 
!!!!!! ATENÇÃO! NÃO DAR COMMIT! !!!!!! 
 
*/
 
 
 
 
DT_ACERTO_CONTA_W		timestamp;
NR_INTERNO_CONTA_W		bigint;
CD_CONVENIO_CALCULO_W		bigint;
CD_CATEGORIA_CALCULO_W		varchar(100);
qt_conta_guia_w			bigint;
cd_estabelecimento_w		bigint;
NR_ATENDIMENTO_W		bigint;
cd_setor_atendimento_w		bigint;
cd_convenio_w			bigint;
cont_w				bigint;
ie_status_acerto_w		integer;
IE_GERAR_CTA_DIF_TISS_w		varchar(100);
nr_doc_convenio_w 		varchar(100);
CD_CATEGORIA_W			varchar(100);
DT_ATENDIMENTO_W		timestamp;
DT_ENTRADA_W			timestamp;
DT_ALTA_W			timestamp;
cd_motivo_exc_conta_w		MOTIVO_EXC_CONTA.cd_motivo_exc_conta%type;

BEGIN
 
begin 
select	a.nr_doc_convenio, 
	a.nr_interno_conta, 
	coalesce(b.cd_estabelecimento, c.cd_estabelecimento), 
	a.CD_CATEGORIA, 
	a.cd_convenio, 
	a.DT_ATENDIMENTO, 
	c.DT_ENTRADA, 
	c.DT_ALTA, 
	a.cd_setor_atendimento, 
	a.NR_ATENDIMENTO, 
	coalesce(b.ie_status_acerto,1), 
	a.cd_motivo_exc_conta 
into STRICT	nr_doc_convenio_w, 
	nr_interno_conta_w, 
	cd_estabelecimento_w, 
	CD_CATEGORIA_W, 
	cd_convenio_w, 
	DT_ATENDIMENTO_W, 
	DT_ENTRADA_W, 
	DT_ALTA_W, 
	cd_setor_atendimento_w, 
	NR_ATENDIMENTO_W, 
	ie_status_acerto_w, 
	cd_motivo_exc_conta_w 
FROM atendimento_paciente c, material_atend_paciente a
LEFT OUTER JOIN conta_paciente b ON (a.nr_interno_conta = b.nr_interno_conta)
WHERE a.nr_sequencia		= nr_seq_material_p  and a.nr_atendimento	= c.nr_atendimento   LIMIT 1;
exception 
when others then 
	nr_atendimento_w	:= null;
end;
 
begin 
select	coalesce(IE_GERAR_CTA_DIF_TISS, 'N') 
into STRICT	IE_GERAR_CTA_DIF_TISS_w 
from	tiss_parametros_convenio 
where	cd_estabelecimento	= cd_estabelecimento_w 
and	cd_convenio		= cd_convenio_w  LIMIT 1;
exception 
when others then 
	IE_GERAR_CTA_DIF_TISS_w	:= 'N';
end;
 
begin 
select	1 
into STRICT	qt_conta_guia_w 
from	conta_paciente_guia 
where	nr_interno_conta	= nr_interno_conta_w 
and	cd_autorizacao		= nr_doc_convenio_w  LIMIT 1;
exception 
when others then 
	qt_conta_guia_w		:= 0;
end;
 
 
if (NR_ATENDIMENTO_W IS NOT NULL AND NR_ATENDIMENTO_W::text <> '') and (qt_conta_guia_w = 0) and (IE_GERAR_CTA_DIF_TISS_w = 'S') and (nr_doc_convenio_w IS NOT NULL AND nr_doc_convenio_w::text <> '') and (ie_status_acerto_w = 1) and (coalesce(cd_motivo_exc_conta_w::text, '') = '')then 
 
	select	count(*) 
	into STRICT	cont_w 
	from (SELECT	1 
		from	procedimento_paciente 
		where	nr_interno_conta	= nr_interno_conta_w 
		
union all
 
		SELECT	2 
		from	material_atend_paciente 
		where	nr_interno_conta	= nr_interno_conta_w) alias8;
 
	-- Edgar 11/10/2007, OS 70483, tratamento para não abrir conta zerada 
	if (cont_w = 0) or (cont_w > 1) or (coalesce(nr_interno_conta_w, 0) = 0) then 
		begin 
		SELECT * FROM Obter_conta_paciente(cd_estabelecimento_w, NR_ATENDIMENTO_W, cd_convenio_w, CD_CATEGORIA_W, NM_USUARIO_P, DT_ATENDIMENTO_W, DT_ENTRADA_W, DT_ALTA_W, nr_doc_convenio_w, cd_setor_atendimento_w, null, DT_ACERTO_CONTA_W, NR_INTERNO_CONTA_W, CD_CONVENIO_CALCULO_W, CD_CATEGORIA_CALCULO_W) INTO STRICT DT_ACERTO_CONTA_W, NR_INTERNO_CONTA_W, CD_CONVENIO_CALCULO_W, CD_CATEGORIA_CALCULO_W;
		exception 
			when others then 
				nr_interno_conta_w	:= null;
		end;
 
		if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then 
			update	material_atend_paciente 
			set	nr_interno_conta	= nr_interno_conta_w 
			where	nr_sequencia		= nr_seq_material_p;
		end if;
	end if;
 
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualiza_conta_mat (nr_seq_material_p bigint, nm_usuario_p text) FROM PUBLIC;
