-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_protocolo ( nr_seq_protocolo_p bigint, ie_status_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_w           protocolo_convenio.cd_convenio%type;
ie_tipo_convenio_w     convenio.ie_tipo_convenio%type;
cd_estabelecimento_w    protocolo_convenio.cd_estabelecimento%type;
ie_ctb_online_w         varchar(1);
ie_geracao_w            ctb_regra_geracao_lote_rec.ie_geracao%type;

procedure contabiliza_protocolo is
;
BEGIN
        begin
        select  a.cd_convenio,
                b.ie_tipo_convenio,
                a.cd_estabelecimento
        into STRICT    cd_convenio_w,
                ie_tipo_convenio_w,
                cd_estabelecimento_w
        from    protocolo_convenio a,
                convenio b
        where   b.cd_convenio = a.cd_convenio
        and     a.nr_seq_protocolo = nr_seq_protocolo_p;
        exception when others then
                cd_convenio_w           := null;
                ie_tipo_convenio_w      := null;
                cd_estabelecimento_w    := null;
        end;

        if (coalesce(cd_estabelecimento_w, 0) != 0) then
                ie_ctb_online_w := ctb_online_pck.get_modo_lote( 6, cd_estabelecimento_w);
                ie_geracao_w    := ctb_online_pck.get_geracao_lote_receita(cd_convenio_w, cd_estabelecimento_w, nm_usuario_p, ie_tipo_convenio_w);

                if (ie_ctb_online_w = 'S' and ie_geracao_w = 'FPR') then
                        CALL ctb_contab_onl_lote_receita(nr_seq_protocolo_p  =>  nr_seq_protocolo_p,
                                                    nr_interno_conta_p  =>  null,
                                                    nm_usuario_p        =>  nm_usuario_p,
                                                    dt_referencia_p     =>  null);
                end if;
         end if;
end;

begin

if (coalesce(ie_status_protocolo_p,0) > 0) then

        update  protocolo_convenio
        set     ie_status_protocolo = ie_status_protocolo_p,
                nm_usuario = nm_usuario_p,
                dt_atualizacao = clock_timestamp()
        where   nr_seq_protocolo = nr_seq_protocolo_p;

        if (ie_status_protocolo_p = 2) then
                contabiliza_protocolo;
        end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_protocolo ( nr_seq_protocolo_p bigint, ie_status_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
